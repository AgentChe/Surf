//
//  AppDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 10.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashViewController.make()
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        PurchaseService.shared.configure()
        IDFAService.shared.configure()
        AmplitudeAnalytics.shared.configure()
        FacebookAnalytics.shared.configure()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppStateProxy.ApplicationProxy.didBecomeActive.accept(Void())
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AppStateProxy.ApplicationProxy.didEnterBackground.accept(Void())
    }
}
