//
//  UIViewController-Extension.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/12/24.
//

import JGProgressHUD
import UIKit
import AVKit

extension UIViewController {
    
    static let hud = JGProgressHUD(style: .dark)
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    
    func showMessage(withTitle title: String, message: String,handler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        
        present(alert, animated: true)
    }
    
    
    func showErrorIfNeeded(_ errorOrNil: Error?) {
        guard let error = errorOrNil else { return }
        
        let message =  AuthService.errorMessage(of: error)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
            if message == "エラーが発生しました、再ログインしてもう一度行ってください" {
                let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                loginViewController.modalPresentationStyle = .fullScreen
                loginViewController.message = "再ログインしてください"

                self.present(loginViewController, animated: false)
            }
        }))
       
        present(alert, animated: true)
    }
    
    
    private final class StatusBarView: UIView { }
    
    func setStatusBarBackgroundColor(_ color: UIColor?) {
        for subView in self.view.subviews where subView is StatusBarView {
            subView.removeFromSuperview()
        }
        guard let color = color else { return }
        
        let statusBarView = StatusBarView()
        statusBarView.backgroundColor = color
        self.view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        statusBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        statusBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    
    func showPermissionMessage() {
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch auth {
        case .notDetermined, .restricted , .authorized:
            break
        case .denied:
            let alert = UIAlertController(title: "設定", message: "カメラのアクセス許可をしてください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
            
            present(alert, animated: true)
            
        @unknown default:
            fatalError()
        }
    }


}
