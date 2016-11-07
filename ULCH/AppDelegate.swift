//
//  AppDelegate.swift
//  ULCH
//
//  Created by Smitha on 04/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
//        FIRApp.configure()
        
        if #available(iOS 10, *)
        {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                
                guard error == nil else
                {
                    //Display Error.. Handle Error.. etc..
                    return
                }
                
                if granted
                {
                    //Do stuff here..
                }
                else
                {
                    //Handle user denying permissions..
                }
            }
        }
        else
        {
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }

        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
    //Modification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        if (UserDefaults.standard.object(forKey: userTokenKey) != nil)
        {
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashboardVCNavigation")
            self.window!.rootViewController = vc

        }

        if (UserDefaults.standard.object(forKey: isFirstTimeKey) == nil)
        {
            UserDefaults.standard.set("NO", forKey: isFirstTimeKey)
            saveDefaultLocImageDetailsInDB()
        }
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.prod)
        
        print("TokenFirstTime:\(FIRInstanceID.instanceID().token())")
        
       //Modification
        //let FCMKey = FIRInstanceID.instanceID().token()
//        UserDefaults.standard.set(FCMKey, forKey: FCMTokenKey)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {
        print("Received Notification!")
        print(userInfo)
        
//        if application.applicationState == UIApplicationState.active
//        {
//            alert(appName, message: "a new push not received", parentView: u)
//        }
    }
//Modification
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token()
        {
            print("RefreshedInstanceID token: \(refreshedToken)")
            
        //Modification
            let FCMKey = refreshedToken
            UserDefaults.standard.set(FCMKey, forKey: FCMTokenKey)
            
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        coreDataStack.saveContext()
    }
}

