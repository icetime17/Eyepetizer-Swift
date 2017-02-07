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

enum VideoListType {
    case lastest
    case daily
}

struct ViewModelVideo {
    
    func getVideoList(type: VideoListType = .lastest) -> Observable<[SectionModel<String, ModelVideo>]> {
        switch type {
        case .lastest:
            return getLastestVideoList()
        case .daily:
            return getDailyVideoList()
        }
    }
    
    private func getLastestVideoList() -> Observable<[SectionModel<String, ModelVideo>]> {
        
        return Observable.create({ (observer) -> Disposable in
            var videos = [ModelVideo]()
            var section = [SectionModel<String, ModelVideo>]()
            
            let videoCount = 20
            let urlString = "http://baobab.kaiyanapp.com/api/v1/video/related/2492/?num=\(videoCount)"
            Alamofire.request(urlString).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let videoList = json["videoList"].arrayValue
                    for videoJson in videoList {
                        let id              = videoJson["id"].intValue
                        let title           = videoJson["title"].stringValue
                        let playUrl         = videoJson["playUrl"].stringValue
                        let author          = videoJson["author"].stringValue
                        let coverForFeed    = videoJson["coverForFeed"].stringValue
                        let video = ModelVideo(id: id, title: title, playUrl: playUrl, author: author, coverForFeed: coverForFeed)
                        videos.append(video)
                    }
                    print("getLastestVideoList : \(videos.count)")
                    
                    section = [SectionModel(model: "section", items: videos)]
                    observer.onNext(section)
                    observer.onCompleted()
                case .failure(let error):
                    print(error)
                }
            })
            
            return Disposables.create()
            
        })
    }
    
    private func getDailyVideoList() -> Observable<[SectionModel<String, ModelVideo>]> {
        
        return Observable.create({ (observer) -> Disposable in
            var videos = [ModelVideo]()
            var section = [SectionModel<String, ModelVideo>]()
            
            let dayCount = 2
            let urlString = "http://baobab.kaiyanapp.com/api/v1/feed?num=\(dayCount)"
            Alamofire.request(urlString).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let dailyList = json["dailyList"].arrayValue
                    for dailyJson in dailyList {
                        let dailyVideos = dailyJson["videoList"].arrayValue
                        for videoJson in dailyVideos {
                            let id              = videoJson["id"].intValue
                            let title           = videoJson["title"].stringValue
                            let playUrl         = videoJson["playUrl"].stringValue
                            let author          = videoJson["author"].stringValue
                            let coverForFeed    = videoJson["coverForFeed"].stringValue
                            let video = ModelVideo(id: id, title: title, playUrl: playUrl, author: author, coverForFeed: coverForFeed)
                            videos.append(video)
                        }
                    }
                    print("getDailyVideoList : \(videos.count)")
                    
                    section = [SectionModel(model: "section", items: videos)]
                    observer.onNext(section)
                    observer.onCompleted()
                case .failure(let error):
                    print(error)
                }
            })
            
            return Disposables.create()
            
        })
    }
    
}
