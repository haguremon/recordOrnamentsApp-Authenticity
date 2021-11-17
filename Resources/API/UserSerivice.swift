//
//  UserSerivice.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/23.
//


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
    
    static func updateUser(ownerUid user: User,updateUser: UpdateUser, completion: @escaping(User) -> Void) {
        
            if updateUser.profileImage == nil {
            COLLECTION_USERS.document(user.uid).updateData([
                    "name": updateUser.name as Any
                ]) { error in
                    if let error = error {
                        print("DEBUG: Failed to update user \(error.localizedDescription)")
                    } else { 
                        
                    COLLECTION_USERS.document(user.uid).getDocument { (snapshot, _) in
                    guard let snapshot = snapshot else { return }
                    guard let data = snapshot.data() else { return }
                    let user = User(dictonary: data)
                    completion(user)
                        }
                    }
                }
        
        } else {
            
        ImageService.uploadImage( image: updateUser.profileImage) { (profileImageUrl) in
            COLLECTION_USERS.document(user.uid).updateData([
                    "name": updateUser.name as Any,
                    "profileImageUrl": profileImageUrl as Any
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        
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

}
