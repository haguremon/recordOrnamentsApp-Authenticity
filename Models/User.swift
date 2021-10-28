//
//  User.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/26.
//

import Foundation
import FirebaseAuth


struct User {
    let email: String
    let name: String
    let profileImageUrl: String
    let uid: String
    //これによって
    var isCurrentUser: Bool {
        //現在ログインしてるユーザーとUser.uidが同じ場合 true
        return Auth.auth().currentUser?.uid == uid
        
    }
    
    //辞書型で値が返ってくるので
    init(dictonary: [String: Any]) {
        self.email = dictonary["email"] as? String ?? ""
        self.profileImageUrl = dictonary["profileImageUrl"] as? String ?? ""
        self.name = dictonary["name"] as? String ?? ""
        self.uid = dictonary["uid"] as? String ?? ""
    }
}
