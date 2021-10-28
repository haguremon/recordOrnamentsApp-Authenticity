//
//  OrnamentNavigationViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/23.
//

import UIKit
import FirebaseAuth

class OrnamentNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        let ornamentViewController = storyboard?.instantiateViewController(identifier: "OrnamentViewController") as! OrnamentViewController
        viewControllers = [ornamentViewController]
    }
    func checkIfUserIsLoggedIn() {
        // configurenavigationController()
        if Auth.auth().currentUser == nil  {
            //ログイン中じゃない場合はLoginControllerに移動する
            
            
            DispatchQueue.main.async {
                self.checkIfUserIsLoggedIn()
            }
            
            
            
        }
    }
    
    private func presentToViewController() {
        
        //RegisterViewControllerに移動する
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: false, completion: nil)
        //        let navController = UINavigationController(rootViewController: loginViewController)
        //        navController.modalPresentationStyle = .fullScreen
        //        navController.navigationBar.isHidden = true
        //        DispatchQueue.main.async {
        //
        //            self.present(navController, animated: false, completion: nil)
        //
        //        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
