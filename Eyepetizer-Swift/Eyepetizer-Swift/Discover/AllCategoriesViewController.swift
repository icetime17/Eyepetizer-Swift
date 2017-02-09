//
//  AllCategoriesViewController.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

import RxSwift
import RxDataSources

import CSSwiftExtension


class AllCategoriesViewController: UIViewController {

    lazy var topBar: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.cs.width, height: 50))
        
        let lbTitle = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.cs.width, height: 40))
        lbTitle.text = "全部分类"
        lbTitle.textColor = UIColor.black
        lbTitle.textAlignment = .center
        lbTitle.font = UIFont.boldSystemFont(ofSize: 20)
        v.addSubview(lbTitle)
        
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
            .addDisposableTo(CS_DisposeBag)
        
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: self.topBar.cs.bottom, width: self.view.cs.width, height: self.view.cs.height - self.topBar.cs.bottom), collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        
        let width = (cv.cs.width - 2) / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        cv.register(CategoryCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        
        return cv
    }()
    
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ModelCategory>>()
    
    let viewModel = ViewModelCategory()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        prepareRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(topBar)
        view.addSubview(collectionView)
    }
    
    private func prepareRx() {
        
        // configureCell
        dataSource.configureCell = { (_, cv, indexPath, modelCategory) in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            cell.backgroundColor = UIColor.cs.random
            cell.modelCategory = modelCategory
            return cell
        }
        
        // dataSource
        viewModel.getCategories()
            .bindTo(collectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(CS_DisposeBag)
        
        // select
        collectionView.rx.modelSelected(ModelCategory.self)
            .subscribe(onNext: { (modelCategory) in
                
                guard let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return }
                self.collectionView.deselectItem(at: indexPath, animated: false)
                
                let categoryVideoListVC = CategoryVideoListViewController()
                categoryVideoListVC.modelCategory = modelCategory
                self.present(categoryVideoListVC, animated: true, completion: nil)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(CS_DisposeBag)
        
    }
    
}
