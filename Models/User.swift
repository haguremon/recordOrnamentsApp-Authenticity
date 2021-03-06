//
//  User.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/26.
//

import FirebaseAuth
import UIKit

 struct User {
    let email: String
    let name: String
    let profileImageUrl: String
    let uid: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictonary: [String: Any]) {
        self.email = dictonary["email"] as? String ?? ""
        self.profileImageUrl = dictonary["profileImageUrl"] as? String ?? ""
        self.name = dictonary["name"] as? String ?? ""
        self.uid = dictonary["uid"] as? String ?? ""
    }
}


struct UpdateUser {
    var name: String?
    var profileImage: UIImage?
}
