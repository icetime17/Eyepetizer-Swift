//
//  Global.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import Foundation

import RxSwift


let CS_DisposeBag = DisposeBag()


struct API {
    private static let BaseURL = "http://baobab.kaiyanapp.com/api/v2/"
    // dailyFeed
    static let dailyFeed    = BaseURL + "feed"
    // category
    static let categories   = BaseURL + "categories"
    // weekly ranklist
    static let weeklyRank   = BaseURL + "ranklist?strategy=weekly"
    // monthly ranklist
    static let monthlyRank  = BaseURL + "ranklist?strategy=monthly"
    // total ranklist
    static let totalRank    = BaseURL + "ranklist?strategy=historical"
    // more videos by date
    static let moreByDate   = BaseURL + "videos?strategy=date"
    // share ranklist
    static let shareRank    = BaseURL + "videos?strategy=shareCount"
}

