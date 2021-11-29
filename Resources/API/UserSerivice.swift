//
//  UserSerivice.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/23.
//


import FirebaseAuth
import UIKit

struct UserService {
    
    
    static func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return completion(.failure(SomeError.assertNilError))
        }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let dictonary = snapshot?.data() else { return }
            let user = User(dictonary: dictonary)
            completion(.success(user))
        }
        
    }
    
    
    static func updateUser(ownerUid user: User,updateUser: UpdateUser, completion: @escaping(User) -> Void) {
        
        if updateUser.profileImage == nil {
            COLLECTION_USERS.document(user.uid).updateData([
                "name": updateUser.name as Any
            ]) { error in
                
                guard error == nil else {
                    return print("DEBUG: Failed to update user \(String(describing: error?.localizedDescription))")
                }
                            
                    COLLECTION_USERS.document(user.uid).getDocument { (snapshot, _) in
                        guard let snapshot = snapshot else { return }
                        guard let data = snapshot.data() else { return }
                        let user = User(dictonary: data)
                        completion(user)
                    }
            }
            
        } else {
            
            ImageService.uploadImage( image: updateUser.profileImage) { (profileImageUrl) in
                COLLECTION_USERS.document(user.uid).updateData([
                    "name": updateUser.name as Any,
                    "profileImageUrl": profileImageUrl as Any
                ]) { error in
                    
                    guard error == nil else {
                        return print("DEBUG: Failed to update user \(String(describing: error?.localizedDescription))")
                    }
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
