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

    var modelVideo: ModelVideo! {
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

}
