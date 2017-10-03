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

import Kingfisher
import Hero


class FeedViewController: UIViewController {

    lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 49)
        let tableView = UITableView(frame: frame, style: .plain)
        self.view.addSubview(tableView)
        
        tableView.register(VideoTableViewCell.classForCoder(), forCellReuseIdentifier: "VideoTableViewCell")
        tableView.rowHeight = kScreenWidth() / 4 * 3
        
        return tableView
    }()
    
    
    let CS_DisposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ModelVideo>>()
    
    var viewModel = ViewModelVideo()
    
}

extension FeedViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func prepareForRx() {
        
        // configureCell
        dataSource.configureCell = { (_, tv, indexPath, modelVideo) in
            let cell = tv.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
            cell.backgroundColor = UIColor.cs.random
            cell.modelVideo = modelVideo
            return cell
        }
        
        // dataSource
        viewModel.getVideoList(type: .dailyFeed)
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(CS_DisposeBag)
        
        
        // select
        tableView.rx.modelSelected(ModelVideo.self)
            .subscribe(onNext: { (modelVideo) in
                
                guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
                self.tableView.deselectRow(at: indexPath, animated: false)
                
                let heroTransitionID = "heroTransitionID : videoPlay - \(indexPath.row)"
                self.tableView.cellForRow(at: indexPath)?.heroID = heroTransitionID
                
                self.gotoVideoPlay(modelVideo: modelVideo, heroTransitionID: heroTransitionID)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(CS_DisposeBag)
        
        tableView.rx.contentOffset
            .map { $0.y }
            .subscribe(onNext: { (contentOffset) in
                if contentOffset >= -UIApplication.shared.statusBarFrame.height / 2 {
                    UIApplication.shared.statusBarStyle = .lightContent
                } else {
                    UIApplication.shared.statusBarStyle = .default
                }
                
                if contentOffset < -100 {
                    print("pull to refresh")
                    // TODO:
                    self.viewModel.videos.append(self.viewModel.videos.first!)
                    
                    self.viewModel.section = [SectionModel(model: "section", items: self.viewModel.videos)]
                }
            })
            .addDisposableTo(CS_DisposeBag)
        
    }

}

extension FeedViewController {
    func gotoVideoPlay(modelVideo: ModelVideo!, heroTransitionID: String!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoPlayVC = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController
        videoPlayVC.modelVideo = modelVideo
        
        videoPlayVC.heroTransitionID = heroTransitionID
        
        self.isHeroEnabled = true
        self.present(videoPlayVC, animated: true, completion: nil)
    }
}
