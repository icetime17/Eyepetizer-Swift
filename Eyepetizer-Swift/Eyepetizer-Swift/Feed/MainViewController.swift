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
import Hero


class MainViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(tableView)
        
        tableView.register(VideoTableViewCell.classForCoder(), forCellReuseIdentifier: "VideoTableViewCell")
        tableView.rowHeight = 200
        
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
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let videoPlayVC = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController
                videoPlayVC.modelVideo = modelVideo
                
                let heroTransitionID = "heroTransitionID : videoPlay - \(indexPath.row)"
                self.tableView.cellForRow(at: indexPath)?.heroID = heroTransitionID
                videoPlayVC.heroTransitionID = heroTransitionID
                
                self.isHeroEnabled = true
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
