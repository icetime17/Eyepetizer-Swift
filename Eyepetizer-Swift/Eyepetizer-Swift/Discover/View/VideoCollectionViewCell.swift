//
//  VideoCollectionViewCell.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit
import CSSwiftExtension


class VideoCollectionViewCell: UICollectionViewCell {

    var realmModelVideo: RealmModelVideo! {
        willSet {
            // can not load cover image while using cell's own imageView, don't know why.
            cover.kf.setImage(with: URL(string: newValue.coverForFeed))
            
            lbTitle.text = newValue.title
            lbCategory.text = "#\(newValue.category) / \(newValue.duration.eyepetizerTimeDuration)"
        }
    }
    
    
    lazy var cover: UIImageView = {
        let iv = UIImageView(frame: self.bounds)
        self.addSubview(iv)
        
        let maskView = UIView(frame: iv.bounds)
        maskView.backgroundColor = UIColor(hexString: 0x0, alpha: 0.2)
        self.addSubview(maskView)
        
        return iv
    }()
    
    lazy var bgView: UIView = {
        let v = UIView(frame: CGRect(x: 10,
                                     y: (self.cs.height - 50) / 2,
                                     width: self.cs.width - 10 * 2,
                                     height: 50))
        v.backgroundColor = UIColor.black
        self.addSubview(v)
        
        return v
    }()
    
    lazy var lbTitle: UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: (self.cs.height - 30) / 2, width: self.cs.width, height: 30))
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(lb)
        return lb
    }()
    
    lazy var lbCategory: UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: self.lbTitle.cs.bottom, width: self.cs.width, height: 30))
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(lb)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    func setupUI() {
        bgView.cs.setCornerRadius(radius: 2)
        bgView.alpha = 0.6
        
        let blurView = UIVisualEffectView(frame: bgView.bounds)
        bgView.addSubview(blurView)
        
        blurView.effect = UIBlurEffect(style: .dark)
    }
}
