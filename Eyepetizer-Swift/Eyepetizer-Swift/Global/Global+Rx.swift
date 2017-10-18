//
//  Global+Rx.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 2017/10/17.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import Foundation

protocol CSRxViewModelType {
    associatedtype Input
    associatedtype Output
    
    func tranform(input: Input) -> Output
}

