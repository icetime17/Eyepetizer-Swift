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
    case downloaded
}

/** 
 编译器不允许在struct的closure中使用self。所以这种情况可以使用class
 */
class ViewModelVideo {
    
    var videos = [ModelVideo]()
    var section = [SectionModel<String, ModelVideo>]()
    
    func getVideoList(type: VideoListType = .dailyFeed) -> Observable<[SectionModel<String, ModelVideo>]> {
        switch type {
        case .dailyFeed:
            return getDailyFeed()
        case .downloaded:
            return getDownloaded()
        default:
            return getDailyFeed()
        }
    }
    
    private func getDailyFeed() -> Observable<[SectionModel<String, ModelVideo>]> {
        
        return Observable.create({ (observer) -> Disposable in
            var videos = [ModelVideo]()
            var section = [SectionModel<String, ModelVideo>]()
            
            let parameters: [String: AnyObject] = [
                "num": 2 as AnyObject,
            ]
            Alamofire.request(API.dailyFeed, parameters: parameters)
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        
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
                        }
                        cs_print("getLastestVideoList : \(videos.count)")
                        
                        self.videos.append(contentsOf: videos)
                        
                        section = [SectionModel(model: "section", items: self.videos)]
                        self.section = section
                        
                        observer.onNext(self.section)
                        observer.onCompleted()
                        
                    case .failure(let error):
                        cs_print(error)
                    }
            })
            
            return Disposables.create()
            
        })
    }
    
    private func getDownloaded() -> Observable<[SectionModel<String, ModelVideo>]> {
        return Observable.create({ (observer) -> Disposable in
            var videos = [ModelVideo]()
            var section = [SectionModel<String, ModelVideo>]()
            
            let docDir = FileManager.default.cs.documentsDirectory
            let videosDir = "\(docDir)/downloads/videos"
            var files = [String]()
            do {
                files = try FileManager.default.contentsOfDirectory(atPath: videosDir)
            } catch {
            
            }
            print(files)
            
            for file in files {
                let videoPath = "\(videosDir)/\(file)"
                let video = ModelVideo(id: -1,
                                       title: file,
                                       playUrl: videoPath,
                                       author: "",
                                       coverForFeed: "",
                                       videoDescription: "",
                                       category: "",
                                       duration: -1)
                videos.append(video)
            }
            
            cs_print("downloaded videos : \(videos.count)")
            
            self.videos.append(contentsOf: videos)
            
            section = [SectionModel(model: "section", items: self.videos)]
            self.section = section
            
            observer.onNext(self.section)
            observer.onCompleted()
            
            return Disposables.create()
        })
    }
}
