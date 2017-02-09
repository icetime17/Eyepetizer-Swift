//
//  DiscoverViewController.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources


class DiscoverViewController: UIViewController {

    lazy var topBar: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.cs.width, height: 50))
        
        let lbTitle = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.cs.width, height: 40))
        lbTitle.text = "Discover"
        lbTitle.textColor = UIColor.black
        lbTitle.textAlignment = .center
        lbTitle.font = UIFont.boldSystemFont(ofSize: 20)
        v.addSubview(lbTitle)
        
        let btnLeft = UIButton(frame: CGRect(x: 0, y: 10, width: 100, height: 40))
        btnLeft.setTitle("全部分类", for: .normal)
        btnLeft.setTitleColor(UIColor.darkGray, for: .normal)
        v.addSubview(btnLeft)
        
        btnLeft.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.gotoAllCategories()
                }
            )
            .addDisposableTo(CS_DisposeBag)
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(topBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoAllCategories() {
        let allCategoriesVC = AllCategoriesViewController()
        present(allCategoriesVC, animated: true, completion: nil)
    }
    
}
