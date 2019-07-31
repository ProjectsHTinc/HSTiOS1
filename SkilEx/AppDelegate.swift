//
//  AppDelegate.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 03/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        if GlobalVariables.shared.user_master_id.isEmpty ==  true
        {
           
            let topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
            topWindow?.rootViewController = UIViewController()
            topWindow?.windowLevel = UIWindow.Level.alert + 1
            let alert: UIAlertController =  UIAlertController(title: "SkilEX \nஸ்கில்எக்ஸ்", message: "Choose your langugae \nஉங்கள்மொழியைத்தேர்வுசெய்க", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "தமிழ்", style: .default, handler: { (alertAction) in
                
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "ta")
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "InitialView", bundle: nil)
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "login") as! Login
                self.window?.rootViewController = homePage
                
            }))
            alert.addAction(UIAlertAction.init(title: "English", style: .default, handler: { (alertAction) in
                
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "InitialView", bundle: nil)
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "login") as! Login
                self.window?.rootViewController = homePage
                
            }))
            
            topWindow?.makeKeyAndVisible()
            topWindow?.rootViewController?.present(alert, animated: true, completion:nil)

        }
        else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "MainView", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! Tabbarcontroller
            self.window?.rootViewController = homePage
        }
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        registerForPushNotifications()
        ReachabilityManager.shared.startMonitoring()
        return true
    }
    
    // Permission For Push Notification
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
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
        // Stops monitoring network reachability status changes
        ReachabilityManager.shared.stopMonitoring()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Starts monitoring network reachability status changes
        ReachabilityManager.shared.startMonitoring()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Genrate Device Token
    func application( _ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let device_Token = tokenParts.joined()
        UserDefaults.standard.saveDeviceToken(deviceToken: "sadsdasdasdasdasdasdasd")
        print("Device Token: \(String(describing: device_Token))")
    }
    
    func application(_ application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register: \(error)")
    }
}

