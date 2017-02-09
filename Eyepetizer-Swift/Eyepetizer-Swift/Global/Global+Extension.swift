//
//  Global+Extension.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import Foundation


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
