//
//  FeedViewController.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

import Alamofire
import SwiftyJSON
import Kingfisher

import CSSwiftExtension
import Hero
import DGElasticPullToRefresh


class FeedViewController: UIViewController {

    lazy var tableView: UITableView = {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.view.bounds.width,
                           height: self.view.bounds.height - 49)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.cs_register(VideoTableViewCell.self)
        tableView.rowHeight = kScreenWidth() / 4 * 3
        
        return tableView
    }()
    
    
    let CS_DisposeBag = DisposeBag()
    
    var isVideoListLoading = false
    
    /*
    var viewModel = ViewModelVideo()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, RealmModelVideo>>()
     */
    
    var viewModelVideoList = ViewModelVideoList()
    let dataSource = RxTableViewSectionedReloadDataSource<VideoListSection>()
    
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
}

extension FeedViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    private func setupRx() {
        viewModelVideoList.delegate = self
        
        // configureCell
        dataSource.configureCell = { (_, tv, indexPath, realmModelVideo) in
            let cell = tv.cs_dequeueReusableCell(forIndexPath: indexPath) as VideoTableViewCell
            cell.backgroundColor = UIColor.cs.random
            cell.realmModelVideo = realmModelVideo
            return cell
        }
        
        // dataSource
        /*
        viewModel.getVideoList(type: .dailyFeed)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: CS_DisposeBag)
        */
        
        let videoListInput = ViewModelVideoList.VideoListInput(type: .dailyFeed)
        let videoListOutput = viewModelVideoList.tranform(input: videoListInput)
        videoListOutput.sections
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: CS_DisposeBag)
        
        // 因requestCommand的next事件会触发网络请求
        videoListOutput.requestCommand.onNext(true)
        
        
        // select
        tableView.rx.modelSelected(RealmModelVideo.self)
            .subscribe(onNext: { (realmModelVideo) in
                
                guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
                self.tableView.deselectRow(at: indexPath, animated: false)
                
                let heroTransitionID = "heroTransitionID : videoPlay - \(indexPath.row)"
                self.tableView.cellForRow(at: indexPath)?.heroID = heroTransitionID
                
                self.gotoVideoPlay(realmModelVideo: realmModelVideo, heroTransitionID: heroTransitionID)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: CS_DisposeBag)

        /*
        tableView.rx.contentOffset
            .map { $0.y }
            .subscribe(onNext: { (contentOffset) in
                if contentOffset >= -UIApplication.shared.statusBarFrame.height / 2 {
                    UIApplication.shared.statusBarStyle = .lightContent
                } else {
                    UIApplication.shared.statusBarStyle = .default
                }
                
                if contentOffset < -100 {
                    if self.isVideoListLoading == false {
                        print("pull to refresh")
                        self.isVideoListLoading = true
                        // TODO: How to load more videos?
                        /*
                        cs_print("videos count : \(self.viewModel.videos.count)")
                        self.viewModel.videos.append(contentsOf: self.viewModel.videos)
                        cs_print("videos count : \(self.viewModel.videos.count)")
                         */
                        
                        
                        let parameters: [String: AnyObject] = [
                            "num": 4 as AnyObject,
                            ]
                        Alamofire.request(API.dailyFeed, parameters: parameters).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let value):
                                
                                var videos = [RealmModelVideo]()
                                
                                let json = JSON(value)
                                let issueList = json["issueList"].arrayValue
                                for issue in issueList {
                                    let itemList = issue["itemList"].arrayValue
                                    for item in itemList {
                                        let type                = item["type"].stringValue
                                        if type != "video" {
                                            continue
                                        }
                                        
                                        let data                = item["data"]
                                        
                                        let video               = RealmModelVideo()
                                        video.id                = data["id"].intValue
                                        video.title             = data["title"].stringValue
                                        video.playUrl           = data["playUrl"].stringValue
                                        video.author            = data["author"].stringValue
                                        video.coverForFeed      = data["cover"]["feed"].stringValue
                                        video.videoDescription  = data["description"].stringValue
                                        video.category          = data["category"].stringValue
                                        video.duration          = data["duration"].intValue
                                        
                                        videos.append(video)
                                    }
                                }
                                cs_print("getLastestVideoList : \(videos.count)")
                                
                                DispatchQueue.cs.main {
//                                    var oldDatas = self.viewModelVideoList.videos.value
                                    //                        self.viewModelVideoList.videos.value = oldDatas + [oldDatas.first!]
                                    
//                                    self.viewModelVideoList.videos.value.append(contentsOf: [oldDatas.first!])
                                    
                                    self.viewModelVideoList.videos.value = videos
                                }
                                
                            case .failure(let error):
                                cs_print(error)
                            }
                        })
                    }
                }
            })
            .disposed(by: CS_DisposeBag)
        */
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({
//            self.tableView.dg_stopLoading()
            self.viewModelVideoList.loadMoreVideos()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

}

extension FeedViewController {
    func gotoVideoPlay(realmModelVideo: RealmModelVideo!, heroTransitionID: String!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoPlayVC = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController
        videoPlayVC.realmModelVideo = realmModelVideo
        
        videoPlayVC.heroTransitionID = heroTransitionID
        
        self.isHeroEnabled = true
        self.present(videoPlayVC, animated: true, completion: nil)
    }
}

extension FeedViewController: ViewModelVideoListDelegate {
    func VideoList(viewModel: ViewModelVideoList, isVideoListReloaded: Bool) {
        self.tableView.dg_stopLoading()
    }
}
