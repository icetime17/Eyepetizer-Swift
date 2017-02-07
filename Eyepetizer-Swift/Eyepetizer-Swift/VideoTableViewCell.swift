//
//  VideoTableViewCell.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    lazy var cover: UIImageView = {
        let iv = UIImageView(frame: self.bounds)
        self.insertSubview(iv, at: 0)
        return iv
    }()
    
    lazy var lbTitle: UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: (self.bounds.height - 30) / 2, width: self.bounds.width, height: 30))
        lb.textAlignment = .center
        lb.textColor = UIColor.white
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
