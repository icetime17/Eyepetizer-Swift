//
//  ViewModelCategory.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/9.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

import RxSwift
import RxDataSources

import CSSwiftExtension


struct ViewModelCategory {
    
    func getCategories() -> Observable<[SectionModel<String, ModelCategory>]> {
        
        return Observable.create({ (observer) -> Disposable in
            var categories = [ModelCategory]()
            var section = [SectionModel<String, ModelCategory>]()
            
            Alamofire.request(API.categories).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    for item in json.arrayValue {
                        let id              = item["id"].intValue
                        let name            = item["name"].stringValue
                        let categoryDesc    = item["description"].stringValue
                        let bgPicture       = item["bgPicture"].stringValue
                        let headerImage     = item["headerImage"].stringValue
                        let category = ModelCategory(id: id,
                                                     name: name,
                                                     categoryDesc: categoryDesc,
                                                     bgPicture: bgPicture,
                                                     headerImage: headerImage)
                        categories.append(category)
                    }
                    
                    cs_print("getCategories : \(categories.count)")
                    
                    section = [SectionModel(model: "section", items: categories)]
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
