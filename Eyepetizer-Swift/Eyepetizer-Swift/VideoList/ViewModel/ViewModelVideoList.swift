//
//  ViewModelVideoList.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 2017/10/16.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire
import SwiftyJSON
import CSSwiftExtension


struct VideoListSection {
    var items: [Item]
}

extension VideoListSection: SectionModelType {
    typealias Item = RealmModelVideo
    init(original: VideoListSection, items: [Item]) {
        self = original
        self.items = items
    }
}


protocol ViewModelVideoListDelegate: class {
    func VideoList(viewModel: ViewModelVideoList, isVideoListReloaded: Bool)
}


class ViewModelVideoList {
    weak var delegate: ViewModelVideoListDelegate?
    
    let videos = Variable<[RealmModelVideo]>([])
    var pageIndex = 1
    
    let CS_DisposeBag = DisposeBag()
}

extension ViewModelVideoList: CSRxViewModelType {
    typealias Input = VideoListInput
    typealias Output = VideoListOutput
    
    struct VideoListInput {
        let type: VideoListType
        init(type: VideoListType = .dailyFeed) {
            self.type = type
        }
    }
    struct VideoListOutput {
        // section来更新tableView
        let sections: Driver<[VideoListSection]>
        
        // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
        let requestCommand = PublishSubject<Bool>()
        
        init(sections: Driver<[VideoListSection]>) {
            self.sections = sections
        }
    }
    
    func tranform(input: ViewModelVideoList.VideoListInput) -> ViewModelVideoList.VideoListOutput {
        let sections = videos.asObservable().map { (videos) -> [VideoListSection] in
            return [VideoListSection(items: videos)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = VideoListOutput(sections: sections)
        output.requestCommand
            .subscribe(onNext: { [unowned self] (isDataLoaded) in
            self.pageIndex = 1
            
            let parameters: [String: AnyObject] = [
                "num": 2 as AnyObject,
                ]
            Alamofire.request(API.dailyFeed, parameters: parameters).responseJSON(completionHandler: { (response) in
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
                    cs_print("getLastestVideoList : \(videos.count)")
                    
                    // reload tableView
                    self.videos.value = videos
                    
                case .failure(let error):
                    cs_print(error)
                }
            })
            
        }).disposed(by: self.CS_DisposeBag)
        
        return output
    }
}

extension ViewModelVideoList {
    func loadMoreVideos() {
        let parameters: [String: AnyObject] = [
            "num": 4 as AnyObject,
            ]
        Alamofire.request(API.dailyFeed, parameters: parameters).responseJSON(completionHandler: { (response) in
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
                cs_print("load more videos : \(videos.count)")
                
                DispatchQueue.cs.main {
                    self.videos.value = videos
                    self.delegate?.VideoList(viewModel: self, isVideoListReloaded: true)
                }
                
            case .failure(let error):
                cs_print(error)
                self.delegate?.VideoList(viewModel: self, isVideoListReloaded: false)
            }
        })
    }
}
