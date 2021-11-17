//
//  SceneDelegate.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/03.
//

import UIKit
import Firebase
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let _ = (scene as? UIWindowScene) else { return }
                
        if Auth.auth().currentUser != nil {
            skipLogin()
        }
    }
    
    func skipLogin() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let ornamentViewController = storyboard.instantiateViewController(identifier: "OrnamentViewController")
        let navVC = UINavigationController(rootViewController: ornamentViewController)

        window?.rootViewController =  navVC
        window?.makeKeyAndVisible()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {

    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {

    }
    
    func sceneWillResignActive(_ scene: UIScene) {
       
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {

    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {

    }
    
    
}

