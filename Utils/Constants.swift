//
//  Constants.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/23.
//

import Firebase


typealias FirestoreCompletion = (Error?) -> Void

let COLLECTION_USERS = Firestore.firestore().collection("users")

let COLLETION_POSTS = Firestore.firestore().collection("posts")
