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
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping FirestoreCompletion) {
        print("DEBUG: Credentials are \(credentials)")
//
        ImageUploader.uploadImage(image: credentials.profileImage) { (imageUrl) in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: Failed to register user\(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
//                //fieldに追加するデータ達
                let data: [String: Any] = [
                    "email": credentials.email,
                    "name": credentials.name,
                    "profileImageUrl": imageUrl,
                    "uid": uid
                 ]
               //collection("users"）のパスが被ることがないuidのでキュメントにdataをつける
                COLLECTION_USERS.document(uid).setData(data,  completion:  completion)
            }
       }
    }
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?){
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
