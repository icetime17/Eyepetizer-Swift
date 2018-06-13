 //
//  VideoTableViewCell.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
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
    
    var realmModelVideo: RealmModelVideo! {
        willSet {
            // can not load cover image while using cell's own imageView, don't know why.
            cover.kf.setImage(with: URL(string: newValue.coverForFeed))
            
            lbTitle.text = newValue.title
            lbCategory.text = "#\(newValue.category) / \(newValue.duration.eyepetizerTimeDuration)"
        }
    }
}
