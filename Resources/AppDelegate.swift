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
        Database.database().isPersistenceEnabled = true
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 0.8821483254, green: 0.8769047856, blue: 0.8861791492, alpha: 0.7161113411)
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
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    
}

