//
//  Global+Methods.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 2017/9/2.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

func kScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

func kScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}

func timeString(_ time: Int) -> String {
    let hour = time / 3600
    let min = time / 60
    let sec = time % 60
    
    var minStr = ""
    var secStr = ""
    minStr = min > 9 ? "\(min)" : "0\(min)"
    secStr = sec > 9 ? "\(sec)" : "0\(sec)"
    
    if hour == 0 {
        return "\(minStr):\(secStr)"
    } else {
        var hourStr = ""
        hourStr = hour > 9 ? "\(hour)" : "0\(hour)"
        return "\(hourStr):\(minStr):\(secStr)"
    }
}
