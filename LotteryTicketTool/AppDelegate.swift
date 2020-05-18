//
//  AppDelegate.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 12/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import UIKit
import WCDBSwift
import BackgroundTasks
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var backgroundURLSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "tech.chengluffy.LotteryTicketTool.refresh.url-session.background")
        configuration.isDiscretionary = true
        configuration.timeoutIntervalForRequest = 30

        return URLSession(configuration: configuration)
    }()
    lazy var database: Database = {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let database = Database(withPath: "\(docPath)/tikets.db")
        return database
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        debugPrint(docPath)
        let database = Database(withPath: "\(docPath)/tikets.db")
        do {
            try database.create(table: "ticket", of: Ticket.self)
        } catch let error {
            print(error)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
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

fileprivate let backgroundTaskIdentifier = "tech.chengluffy.LotteryTicketTool.refresh"

extension AppDelegate {
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 10)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Couldn't schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        let url: URL = URL.init(string: "http://f.apiplus.net/dlt-10.json")!
        let dataTask = backgroundURLSession.dataTask(with: url) { (data, response, err) in
            if err == nil {
                do {
                    let resp = try JSONDecoder().decode(Response.self, from: data!)
                    
                    var arr = resp.data.map { (ticket) -> Ticket in
                        var ticket = ticket
                        ticket.cate = 2
                        ticket.degree = 0
                        ticket.ticketPurchased = false
                        return ticket
                    }
                    
                    arr = arr.sorted { (a, b) -> Bool in
                        return a.opentimestamp < b.opentimestamp
                    }
                    
                    do {
                        for ticket in arr {
                            let dataSource: [Ticket] = try self.database.getObjects(on: Ticket.CodingKeys.all, fromTable: "ticket", where: Ticket.Properties.expect == ticket.expect && Ticket.Properties.cate == ticket.cate!)
                            if dataSource.count > 0 {
                            } else {
                                try self.database.insert(objects: arr, intoTable: "ticket")
                            }
                        }
                        task.setTaskCompleted(success: true)
                    } catch {
                        debugPrint(error)
                        task.setTaskCompleted(success: false)
                    }
                    
                } catch let error {
                    debugPrint(error)
                    task.setTaskCompleted(success: false)
                }
                
            } else {
                task.setTaskCompleted(success: false)
            }
        }

        task.expirationHandler = {
            dataTask.cancel()
        }

        dataTask.resume()
    }
    
}

