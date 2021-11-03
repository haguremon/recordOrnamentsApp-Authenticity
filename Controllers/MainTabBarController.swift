//
//  MainTabBarController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/03.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTab()
    }

    func setupTab() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let accountViewController = AccountViewController()
        accountViewController.tabBarItem.isEnabled = true
        
       
       
        //let sideMenuViewController = SideMenuViewController()
      
        let sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenu") as! SideMenuViewController
        sideMenuViewController.tabBarItem.isEnabled = true
        
        let ornamentViewController = storyboard.instantiateViewController(withIdentifier: "OrnamentViewController") as! OrnamentViewController
        ornamentViewController.tabBarItem.isEnabled = true
        
        viewControllers = [accountViewController, ornamentViewController, sideMenuViewController]
    }

}
