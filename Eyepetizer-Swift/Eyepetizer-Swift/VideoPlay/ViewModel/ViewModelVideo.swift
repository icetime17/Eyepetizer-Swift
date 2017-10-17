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
import RealmSwift

import RxSwift
import RxCocoa
import RxDataSources

import CSSwiftExtension


enum VideoListType {
    case dailyFeed
    case weeklyRank
    case monthlyRank
    case totalRank
    case moreByDate
    case shareRank
    case downloaded
}

/** 
 编译器不允许在struct的closure中使用self。所以这种情况可以使用class
 */
class ViewModelVideo {
    
    var videos  = [RealmModelVideo]()
    var section = [SectionModel<String, RealmModelVideo>]()
    var curPageIndex = 1
    
    func getVideoList(type: VideoListType = .dailyFeed) -> Observable<[SectionModel<String, RealmModelVideo>]> {
        switch type {
        case .dailyFeed:
            return getDailyFeed()
        case .downloaded:
            return getDownloaded()
        default:
            return getDailyFeed()
        }
    }
    
    private func getDailyFeed() -> Observable<[SectionModel<String, RealmModelVideo>]> {
        
        return Observable.create({ (observer) -> Disposable in
            let parameters: [String: AnyObject] = [
                "num": 2 * self.curPageIndex as AnyObject,
            ]
            Alamofire.request(API.dailyFeed, parameters: parameters)
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        var videos = [RealmModelVideo]()
                        
                        let json = JSON(value)
                        let issueList = json["issueList"].arrayValue
                        for issue in issueList {
                            let itemList = issue["itemList"].arrayValue
                            for item in itemList {
                                let type                = item["type"].stringValue
                                if type != "video" {
                                    continue
                                }
                                
                                let data                = item["data"]
                                
                                let video               = RealmModelVideo()
                                video.id                = data["id"].intValue
                                video.title             = data["title"].stringValue
                                video.playUrl           = data["playUrl"].stringValue
                                video.author            = data["author"].stringValue
                                video.coverForFeed      = data["cover"]["feed"].stringValue
                                video.videoDescription  = data["description"].stringValue
                                video.category          = data["category"].stringValue
                                video.duration          = data["duration"].intValue
                                
                                videos.append(video)
                            }
                        }
                        cs_print("daily feed page index : \(self.curPageIndex), videos : \(videos.count)")
                        
                        self.curPageIndex = self.curPageIndex + 1
                        
                        self.videos = videos
                        self.section = [SectionModel(model: "section", items: self.videos)]
                        observer.onNext(self.section)
                        // TODO: cannot send completed message if there are more videos to load
                        
                    case .failure(let error):
                        cs_print(error)
                    }
            })
            
            return Disposables.create()
            
        })
    }
    
    private func getDownloaded() -> Observable<[SectionModel<String, RealmModelVideo>]> {
        return Observable.create({ (observer) -> Disposable in
            var videos = [RealmModelVideo]()
            
            let docDir = FileManager.default.cs.documentsDirectory
            let videosDir = "\(docDir)/downloads/videos"
            
            do {
                let realm = try Realm()
                let realmModelVideos = try realm.objects(RealmModelVideo.self)
                for realmModelVideo in realmModelVideos {
                    let videoPath = "\(videosDir)/\(realmModelVideo.playUrl)"
                    if FileManager.default.fileExists(atPath: videoPath) {
                        let video = RealmModelVideo()
                        video.id                = realmModelVideo.id
                        video.title             = realmModelVideo.title
                        video.playUrl           = videoPath
                        video.author            = realmModelVideo.author
                        video.coverForFeed      = realmModelVideo.coverForFeed
                        video.videoDescription  = realmModelVideo.videoDescription
                        video.category          = realmModelVideo.category
                        video.duration          = realmModelVideo.duration
                        
                        videos.append(video)
                    }
                }
            } catch {
                
            }
            
            cs_print("downloaded videos : \(videos.count)")
            
            self.videos.append(contentsOf: videos)
            
            self.section = [SectionModel(model: "section", items: self.videos)]
            
            observer.onNext(self.section)
            observer.onCompleted()
            
            return Disposables.create()
        })
    }
}
