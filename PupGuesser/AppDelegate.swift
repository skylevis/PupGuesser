//
//  AppDelegate.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 31/5/25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootVC = MenuViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        navController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

