//
//  CategoryVideoListViewController.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

import RxSwift
import RxDataSources


class CategoryVideoListViewController: UIViewController {

    var modelCategory: ModelCategory!
    
    var lbTitle: UILabel!
    lazy var topBar: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.cs.width, height: 50))
        
        self.lbTitle = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.cs.width, height: 40))
        self.lbTitle.text = "分类"
        self.lbTitle.textColor = UIColor.black
        self.lbTitle.textAlignment = .center
        self.lbTitle.font = UIFont.boldSystemFont(ofSize: 20)
        v.addSubview(self.lbTitle)
        
        let btnLeft = UIButton(frame: CGRect(x: 0, y: 10, width: 100, height: 40))
        btnLeft.setTitle("返回", for: .normal)
        btnLeft.setTitleColor(UIColor.darkGray, for: .normal)
        v.addSubview(btnLeft)
        
        btnLeft.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            )
            .addDisposableTo(self.CS_DisposeBag)
        
        return v
    }()
    
    
    lazy var collectionViewLastest: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: self.topBar.cs.bottom, width: self.view.cs.width, height: self.view.cs.height - self.topBar.cs.bottom), collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        
        let width = (cv.cs.width - 2) / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        cv.register(VideoCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        
        
        return cv
    }()
    
    
    let CS_DisposeBag = DisposeBag()
    
    let dataSourceLastest = RxCollectionViewSectionedReloadDataSource<SectionModel<String, RealmModelVideo>>()
    
    let viewModelLastest = ViewModelVideo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupRx()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbTitle.text = "#" + modelCategory.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(topBar)
        view.addSubview(collectionViewLastest)
    }
    
    private func setupRx() {
        
        // configureCell
        dataSourceLastest.configureCell = { (_, cv, indexPath, realmModelVideo) in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
            cell.backgroundColor = UIColor.cs.random
            cell.realmModelVideo = realmModelVideo
            return cell
        }
    
        // dataSource
        viewModelLastest.getVideoList()
            .bind(to: collectionViewLastest.rx.items(dataSource: dataSourceLastest))
            .disposed(by: CS_DisposeBag)
        
        // select
        collectionViewLastest.rx.modelSelected(RealmModelVideo.self)
            .subscribe(onNext: { (realmModelVideo) in
                
                guard let indexPath = self.collectionViewLastest.indexPathsForSelectedItems?.first else { return }
                self.collectionViewLastest.deselectItem(at: indexPath, animated: false)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let videoPlayVC = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController
                videoPlayVC.realmModelVideo = realmModelVideo
                
                let heroTransitionID = "heroTransitionID : videoPlay - \(indexPath.row)"
                self.collectionViewLastest.cellForItem(at: indexPath)?.heroID = heroTransitionID
                videoPlayVC.heroTransitionID = heroTransitionID
                
                self.isHeroEnabled = true
                self.present(videoPlayVC, animated: true, completion: nil)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: CS_DisposeBag)
        
    }
    
}
