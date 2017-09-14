//
//  AppDelegate.swift
//  GPA Tracker
//
//  Created by Rabih Mteyrek on 7/1/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftRater
import SwiftyJSON
import SwiftyDropbox
//import GoogleMobileAds
//import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UITabBar.appearance().tintColor = UIColor.init(red: 25/255, green: 126/255, blue: 192/255, alpha: 0.8)
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 25/255, green: 126/255, blue: 192/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false

        //UIApplication.navigationController?.navigationBar.translucent = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        //FirebaseApp.configure()
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-2024178867950672~6640216788")

        if !userDefaults.bool(forKey: "notFirstLaunch") {

            //print("First launch")

            userDefaults.setValue(4.00, forKey: "A+")
            userDefaults.setValue(4.00, forKey: "A")
            userDefaults.setValue(3.67, forKey: "A-")
            userDefaults.setValue(3.33, forKey: "B+")
            userDefaults.setValue(3.00, forKey: "B")
            userDefaults.setValue(2.67, forKey: "B-")
            userDefaults.setValue(2.33, forKey: "C+")
            userDefaults.setValue(2.00, forKey: "C")
            userDefaults.setValue(1.67, forKey: "C-")
            userDefaults.setValue(1.33, forKey: "D+")
            userDefaults.setValue(1.33, forKey: "D")
            userDefaults.setValue(1.00, forKey: "D-")
            userDefaults.setValue(0.00, forKey: "F")
            userDefaults.set(true, forKey: "notFirstLaunch")
            userDefaults.synchronize()
        }

        DropboxClientsManager.setupWithAppKey("qaayzcvv53rnpyc")

        getYearsArray()
        getCoursesArrayFromJSON()

        if !courses.isEmpty { sortCourses() }

        SwiftRater.daysUntilPrompt = 7
        SwiftRater.usesUntilPrompt = 10
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = false
        SwiftRater.appLaunched()

        /*let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1]
        navigationController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self*/
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        
        //Handle DropBox redirect
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
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
        // Saves changes in the application's managed object context before the application terminates.
    }
}
