//
//  AppDelegate.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/03.
//

import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        FirebaseApp.configure()
        if #available(iOS 13.0, *) {
           let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 0.7712653279, green: 0.76668185, blue: 0.7747893929, alpha: 0.520540149)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().standardAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        sleep(2)

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

