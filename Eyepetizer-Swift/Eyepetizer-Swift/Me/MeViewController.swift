//
//  MeViewController.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

import RxSwift
import RxDataSources

class MeViewController: UIViewController {

    let CS_DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btnLeft = UIButton(frame: CGRect(x: 0, y: 10, width: 100, height: 40))
        btnLeft.setTitle("已下载", for: .normal)
        btnLeft.setTitleColor(UIColor.darkGray, for: .normal)
        self.view.addSubview(btnLeft)
        btnLeft.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.gotoDownloadedVideos()
                }
            )
            .addDisposableTo(self.CS_DisposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoDownloadedVideos() {
        let downloadedVieosVC = DownloadedVideosViewController()
        downloadedVieosVC.modelCategory = ModelCategory(id: -1, name: "已下载", categoryDesc: "已下载", bgPicture:  "", headerImage: "")
        self.present(downloadedVieosVC, animated: true, completion: nil)
    }
}
