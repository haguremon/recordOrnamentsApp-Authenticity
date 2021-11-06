//
//  UserSerivice.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/23.
//

import Foundation
import FirebaseAuth
import UIKit

struct UserService {
    
    static func fetchUser(completion: @escaping (User) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let dictonary = snapshot?.data() else { return }
            let user = User(dictonary: dictonary)
            completion(user)
            
        }
    }
    static func updateUser(ownerUid user: User,updateUser: UpdateUser, image: UIImage?, completion: @escaping(User) -> Void) {
        
//        let query = COLLETION_POSTS.whereField("ownerUid", isEqualTo: uid.ownerUid)
        ImageUploader.uploadImage(image: image) { (profileImageUrl) in
            COLLETION_POSTS.document(user.uid).updateData([ // アップデート
                    "name": updateUser.name as Any,
                    "profileImageUrl": profileImageUrl as Any
                ]) { err in
                    if let err = err { // エラーハンドリング
                        print("Error updating document: \(err)")
                    } else { // 書き換え成功ハンドリング
                        
                    COLLECTION_USERS.document(user.uid).getDocument { (snapshot, _) in
                    guard let snapshot = snapshot else { return }
                    guard let data = snapshot.data() else { return }
                    let user = User(dictonary: data)
                    completion(user)
                        }
                    
                    }
                }
            
        }
  
        
    }
    
    
}
