 //
//  VideoTableViewCell.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit
import CSSwiftExtension


class VideoTableViewCell: UITableViewCell {

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
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var lbTitle: UILabel = {
        let lb = UILabel(frame: CGRect(x: 0,
                                       y: (self.cs.height - 30) / 2,
                                       width: self.cs.width,
                                       height: 30))
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbCategory: UILabel = {
        let lb = UILabel(frame: CGRect(x: 0,
                                       y: self.lbTitle.cs.bottom,
                                       width: self.cs.width,
                                       height: 30))
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(cover)
        addSubview(lbTitle)
        addSubview(lbCategory)
    }
}
