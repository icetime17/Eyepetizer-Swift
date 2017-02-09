//
//  VideoTableViewCell.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit
import CSSwiftExtension


extension Int {

    var eyepetizerTimeDuration: String {
        let hour = self / 3600
        let min = self / 60
        let sec = self % 60
        
        var minStr = ""
        var secStr = ""
        minStr = min > 9 ? "\(min)" : "0\(min)"
        secStr = sec > 9 ? "\(sec)" : "0\(sec)"
        
        if hour == 0 {
            return "\(minStr)'\(secStr)\""
        } else {
            var hourStr = ""
            hourStr = hour > 9 ? "\(hour)" : "0\(hour)"
            return "\(hourStr)'\(minStr)'\(secStr)\""
        }
    }
    
}

class VideoTableViewCell: UITableViewCell {

    var modelVideo: ModelVideo! {
        didSet {
            // can not load cover image while using cell's own imageView, don't know why.
            cover.kf.setImage(with: URL(string: modelVideo.coverForFeed))
            
            lbTitle.text = modelVideo.title
            lbCategory.text = "#\(modelVideo.category) / \(modelVideo.duration.eyepetizerTimeDuration)"
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
