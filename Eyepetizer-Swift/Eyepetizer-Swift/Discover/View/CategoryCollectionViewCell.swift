//
//  CategoryCollectionViewCell.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    var modelCategory: ModelCategory! {
        willSet {
            cover.kf.setImage(with: URL(string: newValue.bgPicture))
                
            lbTitle.text = newValue.name
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
    
}
