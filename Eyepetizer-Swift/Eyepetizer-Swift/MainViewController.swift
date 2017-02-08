//
//  MainViewController.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

import Kingfisher

class MainViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(tableView)
        
        tableView.register(VideoTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 150
        
        return tableView
    }()
    
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ModelVideo>>()
    
    
    let viewModel = ViewModelVideo()
    
}

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForRx()
    }
    
    func prepareForRx() {
        
        // configure
        dataSource.configureCell = { (_, tv, indexPath, video) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VideoTableViewCell
            
            cell.lbTitle.text = video.title
            // can not load cover image while using cell's own imageView, don't know why.
            cell.cover.kf.setImage(with: URL(string: video.coverForFeed))
            
            return cell
        }
        
        // dataSource
        viewModel.getVideoList(type: .lastest)
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(CS_DisposeBag)
        
        
        // select
        tableView.rx.modelSelected(ModelVideo.self)
            .subscribe(onNext: { (video) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let videoPlayVC = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController
                videoPlayVC.video = video
                self.present(videoPlayVC, animated: true, completion: nil)
                
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
            })
            .addDisposableTo(CS_DisposeBag)
        
    }

}
