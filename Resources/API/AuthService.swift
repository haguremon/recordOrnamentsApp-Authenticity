//
//  AuthService.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/23.
//

import UIKit
import Firebase
//Authに送る情報モデルの作成
struct AuthCredentials {
    let email: String
    let password: String
    let name: String
    let profileImage: UIImage?
}

struct  AuthService {
    
    
    static func registerUser(_ viewControllerw: UIViewController,button: UIButton,withCredential credentials: AuthCredentials, completion: @escaping FirestoreCompletion) {
        print("DEBUG: Credentials are \(credentials)")
//
        ImageService.uploadImage(image: credentials.profileImage) { (imageUrl) in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
          
                if let error = error {
                    viewControllerw.showErrorIfNeeded(error)
                    button.showSuccessAnimation(false)
                    button.isEnabled = true
                    button.backgroundColor = .red
                    return
                }
                guard let user = result?.user else { return }
                let req = user.createProfileChangeRequest()
                req.displayName = credentials.name
                req.commitChanges { error in
                    
                    user.sendEmailVerification { error in
                        guard let error = error else { return }
                        viewControllerw.showErrorIfNeeded(error)
                        button.isEnabled = true
                        button.showSuccessAnimation(false)
                        button.backgroundColor = .red

                    }
                }
            
                guard let uid = result?.user.uid else { return }

                let data: [String: Any] = [
                    "email": credentials.email,
                    "name": credentials.name,
                    "profileImageUrl": imageUrl,
                    "uid": uid
                 ]
               
                COLLECTION_USERS.document(uid).setData(data,  completion: completion)
            }
       }
        
    }
    
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?){
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    
    static func errorMessage(of error: Error) -> String {
        var message = "エラーが発生しました、再ログインしてもう一度行ってください"
        guard let errcd = AuthErrorCode(rawValue: (error as NSError).code) else {
            return message
        }
    
        switch errcd {
        case .networkError: message = "ネットワークに接続してください"
        case .userNotFound: message = "ユーザが見つかりません"
        case .invalidEmail: message = "不正なメールアドレスです"
        case .emailAlreadyInUse: message = "このメールアドレスは既に使われています"
        case .wrongPassword: message = "入力した認証情報でサインインできません"
        case .userDisabled: message = "このアカウントは無効です"
        case .weakPassword: message = "パスワードが脆弱すぎます"
        case .accountExistsWithDifferentCredential: message = "エラーが発生しました、再ログインしてもう一度行ってください"
        case .invalidDynamicLinkDomain: message = "エラーが発生しました、再ログインしてもう一度行ってください"
        
        case .nullUser: message = "test1"
            
        
        default: break
        }
        return message
    }

    
}
