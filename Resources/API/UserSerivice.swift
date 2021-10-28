//
//  UserSerivice.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/23.
//

import Foundation
import FirebaseAuth

struct UserService {
    
    static func fetchUser(completion: @escaping (User) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let dictonary = snapshot?.data() else { return }
            let user = User(dictonary: dictonary)
            completion(user)
            
        }
    }
}
