//
//  AppDelegate.swift
//  SecretVault
//
//  Created by User01 on 8/27/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftyDropbox
import OneDriveSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isLoginedDropboxAccount = false
    var isLoginedDropboxAccountOneTime = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let navController = UINavigationController(rootViewController: MainCalculator())
////        navController.navigationBar.isTranslucent       = false
////        navController.navigationBar.barTintColor        = Color.navBgColor
////        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.yellowTextColor]
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window!.rootViewController = navController
//
//        self.window?.makeKeyAndVisible()
//
        window = UIWindow(frame: UIScreen.main.bounds)
        let launchingVC = MainCalculator.loadFromNib()
        window?.rootViewController = launchingVC
        window?.makeKeyAndVisible()
        
        
        GIDSignIn.sharedInstance().clientID = Constants.GoogleKey.clientID

        DropboxClientsManager.setupWithAppKey(Constants.DropboxKey.fullDropboxAppKey)
        
        ODClient.setMicrosoftAccountAppId(Constants.OneDriveKey.clienId, scopes: ["onedrive.readwrite"])
        
        if UserDefaults.standard.object(forKey: "FirstRunApp") == nil {
            UserDefaults.standard.set(true, forKey: "FirstRunApp")
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
        window = UIWindow(frame: UIScreen.main.bounds)
               let launchingVC = MainCalculator.loadFromNib()
               window?.rootViewController = launchingVC
               window?.makeKeyAndVisible()
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            IntersititialController.sharedInstance.showIntersititial()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: sourceApplication,
                                          annotation: annotation)
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                self.isLoginedDropboxAccount = true
                self.isLoginedDropboxAccountOneTime = true                
                print("Success! User is logged into DropboxClientsManager.")
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
        return true
    }


}

