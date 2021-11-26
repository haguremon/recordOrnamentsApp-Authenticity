//
//  Post.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/26.
//

import Firebase

struct Post {
    var caption: String
    let imageUrl: String
    let imagename: String
    let ownerUid: String
    let creationDate: Timestamp
    let editDate: Timestamp?
    
    let postId: String
  
    let ownerUsername: String
    
    let password: String?
    var isSetPassword:  Bool
    
    init(postId: String, dictonary: [String: Any]) {
        self.caption = dictonary["caption"] as? String ?? ""
        self.imageUrl = dictonary["imageUrl"] as? String ?? ""
        self.imagename = dictonary["imagename"] as? String ?? ""
        self.ownerUid = dictonary["ownerUid"] as? String ?? ""
        self.creationDate = dictonary["creationDate"] as? Timestamp ?? Timestamp(date: Date())
        self.editDate = dictonary["editDate"] as? Timestamp
        self.postId = postId
        self.password = dictonary["password"] as? String
        self.isSetPassword = dictonary["isSetPassword"] as? Bool ?? false
        self.ownerUsername = dictonary["ownerUsername"] as? String ?? ""
    }
    
}


struct Submissions {
    var caption: String?
    var imagename: String?
    var password: String?
    var isSetPassword: Bool?
}


struct ResetData {
    var password: String?
    var isSetPassword: Bool?
}
