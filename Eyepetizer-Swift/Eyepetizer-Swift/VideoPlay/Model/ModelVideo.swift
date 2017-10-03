//
//  ModelVideo.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import Foundation

struct ModelVideo {

    let id              : Int
    let title           : String
    let playUrl         : String
    let author          : String
    let coverForFeed    : String
    let videoDescription: String
    let category        : String
    let duration        : Int
    
}


/*
 
 "type": "video",
 "data": {
 "dataType": "VideoBeanForClient",
 "id": 12192,
 "title": "假期的温情：「瞬间 Moments」",
 "description": "英国著名旅行公司 Thomson 借势全球火热的假人挑战，推出了创意广告片「时光 Moments」。总有那么一刻，我们幸福得希望时间可以静止。找回真我，享受真正难忘的瞬间，这便是旅行的意义……From Ad Heaven 2",
 "provider": {
 "name": "YouTube",
 "alias": "youtube",
 "icon": "http://img.kaiyanapp.com/fa20228bc5b921e837156923a58713f6.png"
 },
 "category": "广告",
 "author": null,
 "cover": {
 "feed": "http://img.kaiyanapp.com/0f296c9bfc70ed5d9ce964b684a6a51e.jpeg?imageMogr2/quality/60/format/jpg",
 "detail": "http://img.kaiyanapp.com/0f296c9bfc70ed5d9ce964b684a6a51e.jpeg?imageMogr2/quality/60/format/jpg",
 "blurred": "http://img.kaiyanapp.com/d6c88b593d9b36c9a008f5c6de5bcf10.jpeg?imageMogr2/quality/60/format/jpg",
 "sharing": null,
 "homepage": "http://img.kaiyanapp.com/2c2979aba2159a9b275d87388e090cb5.jpeg?imageView2/1/w/720/h/560/format/jpg/q/75|watermark/1/image/aHR0cDovL2ltZy5rYWl5YW5hcHAuY29tL2JsYWNrXzMwLnBuZw==/dissolve/100/gravity/Center/dx/0/dy/0|imageslim",
 },
 "playUrl": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=12192&editionType=default&source=ucloud",
 "thumbPlayUrl": "http://baobab.kaiyanapp.com/api/v1/playUrl/1503652052049_70f1344f.mp4?vid=12292&source=qcloud",
 "duration": 60,
 "webUrl": {
 "raw": "http://www.eyepetizer.net/detail.html?vid=12192",
 "forWeibo": "http://wandou.im/3l2goq"
 },
 "releaseTime": 1486602000000,
 "library": "DAILY",
 "playInfo": [
 {
 "height": 480,
 "width": 854,
 "urlList": [
 {
 "name": "ucloud",
 "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=12192&editionType=normal&source=ucloud"
 "size": 20650198
 },
 {
 "name": "qcloud",
 "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=12192&editionType=normal&source=qcloud"
 "size": 20650198
 }
 ],
 "name": "标清",
 "type": "normal",
 "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=12192&editionType=normal&source=ucloud"
 },
 {
 "height": 720,
 "width": 1280,
 "urlList": [
 {
 "name": "ucloud",
 "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=12192&editionType=high&source=ucloud"
 },
 {
 "name": "qcloud",
 "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=12192&editionType=high&source=qcloud"
 }
 ],
 "name": "高清",
 "type": "high",
 "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=12192&editionType=high&source=ucloud"
 }
 ],
 "consumption": {
 "collectionCount": 62,
 "shareCount": 80,
 "replyCount": 2
 },
 "campaign": null,
 "waterMarks": null,
 "adTrack": null,
 "tags": [
 {
 "id": 10,
 "name": "旅行",
 "actionUrl": "eyepetizer://tag/10/?title=%E6%97%85%E8%A1%8C",
 "adTrack": null
 },
 {
 "id": 666,
 "name": "生活",
 "actionUrl": "eyepetizer://tag/666/?title=%E7%94%9F%E6%B4%BB",
 "adTrack": null
 },
 {
 "id": 16,
 "name": "广告",
 "actionUrl": "eyepetizer://tag/16/?title=%E5%B9%BF%E5%91%8A",
 "adTrack": null
 },
 {
 "id": 675,
 "name": "摄影艺术",
 "actionUrl": "eyepetizer://tag/675/?title=%E6%91%84%E5%BD%B1%E8%89%BA%E6%9C%AF",
 "adTrack": null
 },
 {
 "id": 110,
 "name": "亲情",
 "actionUrl": "eyepetizer://tag/110/?title=%E4%BA%B2%E6%83%85",
 "adTrack": null
 },
 {
 "id": 2,
 "name": "创意",
 "actionUrl": "eyepetizer://tag/2/?title=%E5%88%9B%E6%84%8F",
 "adTrack": null
 }
 ],
 "type": "NORMAL",
 "titlePgc": null,
 "descriptionPgc": null,
 "remark": "",
 "idx": 0,
 "shareAdTrack": null,
 "favoriteAdTrack": null,
 "webAdTrack": null,
 "date": 1504314000000,
 "promotion": null,
 "label": null,
 "labelList": [],
 "descriptionEditor": "兰萨罗特岛（Lanzarote）是一座地处西班牙的火山岛，也是大西洋加那利群岛中的第四大岛。在拍摄中，有过寒冷、孤独、食不果腹，但能有幸记录下如此绝美的景色，一切辛苦都是值得的。From Gustavo Medina",
 "collected": false,
 "played": false,
 "subtitles": [],
 "lastViewTime": null,
 "playlists": null
 }
 */
