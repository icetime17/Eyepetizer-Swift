//
//  ModelVideo.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/7.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import Foundation

struct ModelVideo {

    let id      : Int
    let title   : String
    let playUrl : String
    let author  : String
    let coverForFeed: String
}


/*
 
 {
     "dataType": "VideoBeanForClientV1",
     "id": 1818,
     "title": "布拉格的三天三夜",
     "description": "拥有「千塔之城」、「金色城市」美称的捷克首都布拉格，有着浓郁的文化气氛和层出不穷的文化活动。一位旅人把在这里三天三夜的记忆转换为了一帧帧美妙的画面。From Yiannis Kostavaras",
     "provider": {
        "name": "Vimeo",
        "alias": "vimeo",
        "icon": "http://img.kaiyanapp.com/c3ad630be461cbb081649c9e21d6cbe3.png"
     },
     "category": "旅行",
     "author": null,
     "playUrl": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=1818&editionType=default&source=ucloud",
     "duration": 115,
     "releaseTime": 1437494400000,
     "playInfo": [
         {
            "height": 480,
            "width": 720,
            "urlList": [
                {
                    "name": "ucloud",
                    "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=1818&editionType=normal&source=ucloud"
                },
                {
                    "name": "qcloud",
                    "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=1818&editionType=normal&source=qcloud"
                }
            ],
            "name": "标清",
            "type": "normal",
            "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=1818&editionType=normal&source=ucloud"
        },
        {
            "height": 720,
            "width": 1280,
            "urlList": [
                {
                    "name": "ucloud",
                    "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=1818&editionType=high&source=ucloud"
                },
                {
                    "name": "qcloud",
                    "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=1818&editionType=high&source=qcloud"
                }
            ],
            "name": "高清",
            "type": "high",
            "url": "http://baobab.kaiyanapp.com/api/v1/playUrl?vid=1818&editionType=high&source=ucloud"
         }
     ],
     "consumption": {
         "collectionCount": 2570,
         "shareCount": 1810,
         "replyCount": 1
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
             "id": 370,
             "name": "欧洲",
             "actionUrl": "eyepetizer://tag/370/?title=%E6%AC%A7%E6%B4%B2",
             "adTrack": null
         },
         {
             "id": 534,
             "name": "人文",
             "actionUrl": "eyepetizer://tag/534/?title=%E4%BA%BA%E6%96%87",
             "adTrack": null
         },
         {
             "id": 196,
             "name": "清新",
             "actionUrl": "eyepetizer://tag/196/?title=%E6%B8%85%E6%96%B0",
             "adTrack": null
         }
     ],
     "type": "NORMAL",
     "idx": 0,
     "shareAdTrack": null,
     "favoriteAdTrack": null,
     "webAdTrack": null,
     "date": 1437494400000,
     "promotion": null,
     "label": null,
     "collected": false,
     "played": false,
     "coverForFeed": "http://img.kaiyanapp.com/7cf774ad49a5dadb4c695194c1957c9d.jpeg?imageMogr2/quality/100",
     "coverForDetail": "http://img.kaiyanapp.com/7cf774ad49a5dadb4c695194c1957c9d.jpeg?imageMogr2/quality/100",
     "coverBlurred": "http://img.kaiyanapp.com/f423b3bfdb93c2694506e56fe52a4af6.jpeg?imageMogr2/quality/100",
     "coverForSharing": null,
     "webUrlForWeibo": "http://wandou.im/laxj3",
     "rawWebUrl": "http://www.eyepetizer.net/detail.html?vid=1818"
 },
 
 */
