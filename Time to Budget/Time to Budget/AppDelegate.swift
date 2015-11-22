//
//  AppDelegate.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/22/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil))
        
        let realm = Database.getRealm()
        
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE")
        
        if Database.debugEnabled {
            print("AppDelegate->Current Budgets:")
            for current in currentBudget {
                print(current.name)
            }
            
            print("AppDelegate->CurrentBudgetCount: ", currentBudget.count)
        }
        
        if currentBudget.count == 0 {
            Database.newBudget()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let realm = Database.getRealm()
        
        let budget = realm.objects(Budget).filter("isCurrent == TRUE").first!
        
        if budget.checkPassedEndDate() {
            Database.newBudget()
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        Database.newBudget()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

