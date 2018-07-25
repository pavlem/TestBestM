//
//  AppDelegate.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setRootViewController()
        setRealmDBConfig()
        startRealmDBInstance()
       
        return true
    }
    
    // MARK: - Helper
    private func setRootViewController() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: getRootViewController())
    }
    
    private func getRootViewController() -> UIViewController {
        return UIStoryboard.mainVC
    }
    
    // MARK: - Help
    func setRealmDBConfig() {
        DbHelper.shared.setRealmConfig()
    }
    
    func startRealmDBInstance() {
        DbHelper.shared.startRealmDBInstance()
    }
}
