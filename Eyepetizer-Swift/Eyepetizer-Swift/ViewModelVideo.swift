//
//  ViewModelVideo.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

import RxSwift
import RxDataSources

import CSSwiftExtension


enum VideoListType {
    case dailyFeed
    case weeklyRank
    case monthlyRank
    case totalRank
    case moreByDate
    case shareRank
}

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

struct ViewModelVideo {
    
    func getVideoList(type: VideoListType = .dailyFeed) -> Observable<[SectionModel<String, ModelVideo>]> {
        switch type {
        case .dailyFeed:
            return getDailyFeed()
        default:
            return getDailyFeed()
        }
    }
    
    private func getDailyFeed() -> Observable<[SectionModel<String, ModelVideo>]> {
        
        return Observable.create({ (observer) -> Disposable in
            var videos = [ModelVideo]()
            var section = [SectionModel<String, ModelVideo>]()
            
            Alamofire.request(API.dailyFeed).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let itemList = json["issueList"][0]["itemList"].arrayValue
                    for item in itemList {
                        let type                = item["type"]
                        let data                = item["data"]
                        let id                  = data["id"].intValue
                        let title               = data["title"].stringValue
                        let playUrl             = data["playUrl"].stringValue
                        let author              = data["author"].stringValue
                        let coverForFeed        = data["cover"]["feed"].stringValue
                        let videoDescription    = data["description"].stringValue
                        let category            = data["category"].stringValue
                        let duration            = data["duration"].intValue
                        let video = ModelVideo(id: id,
                                               title: title,
                                               playUrl: playUrl,
                                               author: author,
                                               coverForFeed: coverForFeed,
                                               videoDescription: videoDescription,
                                               category: category,
                                               duration: duration)
                        videos.append(video)
                    }
                    cs_print("getLastestVideoList : \(videos.count)")
                    
                    section = [SectionModel(model: "section", items: videos)]
                    observer.onNext(section)
                    observer.onCompleted()
                case .failure(let error):
                    cs_print(error)
                }
            })
            
            return Disposables.create()
            
        })
    }
    
}
