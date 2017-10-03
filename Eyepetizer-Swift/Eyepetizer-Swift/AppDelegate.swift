//
//  AppDelegate.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/4.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func otherFuncWhoIsOld(_ age: Int) -> Bool {
        return age > 50
    }
    
    struct Staff {
        var firstname: String
        var lastname: String
        var age: Int
        var salary: Float
    }
    
    let staffs = [
        Staff(firstname:"Ming", lastname:"Zhang", age: 24, salary: 12000.0),
        Staff(firstname:"Yong", lastname:"Zhang", age: 29, salary: 17000.0),
        Staff(firstname:"TianCi", lastname:"Wang", age: 44, salary: 30000.0),
        Staff(firstname:"Mingyu", lastname:"Hu", age: 30, salary: 15000.0),
        Staff(firstname:"TianYun", lastname:"Zhang", age: 25, salary: 12000.0),
        Staff(firstname:"Wang", lastname:"Meng", age: 24, salary: 14000.0)
    ]
    
    func filterGenerator(lastnameCondition: String) -> ((Staff) -> Bool) {
        return { staff in
            return staff.lastname == lastnameCondition
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        func funcWhoIsOld(_ age: Int) -> Bool {
            return age > 50
        }
        
        var closureWhoIsOld = { (age: Int) -> Bool in
            return age > 50
        }
        
        let ages = [18, 48, 68]
        let oldMan1 = ages.filter(funcWhoIsOld(_:))
        
        let oldMan2 = ages.filter(closureWhoIsOld)
        
        let oldMan3 = ages.filter(otherFuncWhoIsOld(_:))
        
        let filterHu = filterGenerator(lastnameCondition: "Hu")
        let hus = staffs.filter(filterHu)
        let filterZhang = filterGenerator(lastnameCondition: "Zhang")
        let zhangs = staffs.filter(filterZhang)
        
        
        
        let fullNames = staffs.map { staff in
            return "\(staff.firstname) \(staff.lastname)"
        }
        
        let averageSalary = staffs.reduce(0.0) { (total, staff) -> Float in
            return total + staff.salary / Float(staffs.count)
        }
        print(averageSalary)
        
        
        // 去重
        let a = ["a", "b", "c", "d", "e", "f", "a", "b"].reduce([]) {
            $0.contains($1) ? $0 : $0 + [$1]
        }
        
        // 去重
        let b = ["a", "b", "c", "d", "e", "f", "a", "b"].reduce([]) { (result, element) -> [String] in
            result.contains(element) ? result : result + [element]
        }
        
        // use to show status bar on ViewController
        application.setStatusBarHidden(false, with: .slide)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

