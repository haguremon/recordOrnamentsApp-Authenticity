//
//  PostService.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/26.
//

import Firebase
import UIKit

struct  PostService {
    //MARK: - Firebaseに保存する処理
    static func uploadPost(caption: String, image: UIImage, imagename: String,setpassword: Bool, password: String?, user: User,completion: @escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageService.uploadImage(image: image) { (imageUrl) in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "imageUrl": imageUrl,
                        "imagename": imagename,
                        "ownerUid": uid,
                        "password": password as Any,
                        "isSetPassword": setpassword,
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername": user.name] as [String: Any]
            
        
            COLLETION_POSTS.addDocument(data: data, completion: completion)
            

        }
    }
    static func updatePost(ownerUid uid: Post,updatepost: Submissions, completion: @escaping(Post) -> Void) {
        
        COLLETION_POSTS.document(uid.postId).updateData([
                "caption": updatepost.caption as Any,
                "imagename": updatepost.imagename as Any,
                "password": updatepost.password as Any,
                "isSetPassword": updatepost.isSetPassword as Any
            ]) { error in
                if let error = error { // エラーハンドリング
                    print("DEBUG: Failed to update Post \(error.localizedDescription)")
                } else { // 書き換え成功ハンドリング
                    
                COLLETION_POSTS.document(uid.postId).getDocument { (snapshot, _) in
                guard let snapshot = snapshot else { return }
                guard let data = snapshot.data() else { return }
                let post = Post(postId: snapshot.documentID, dictonary: data)
                completion(post)
                    }
                
                }
            }
        
        
    }
    
    static func resetPasswordPost(ownerUid uid: Post,updatepost: ResetData, completion: @escaping(Post) -> Void) {
                COLLETION_POSTS.document(uid.postId).updateData([ // アップデー
                        "password": updatepost.password as Any,
                        "isSetPassword": updatepost.isSetPassword as Any
                    ]) { error in
                        if let error = error { // エラーハンドリング
                            print("DEBUG: Failed to resetPassword Post \(error.localizedDescription)")
                        } else { // 書き換え成功ハンドリング
                            
                        COLLETION_POSTS.document(uid.postId).getDocument { (snapshot, _) in
                        guard let snapshot = snapshot else { return }
                        guard let data = snapshot.data() else { return }
                        let post = Post(postId: snapshot.documentID, dictonary: data)
                        completion(post)
                            }
                        
                        }
                    }
                
                
            }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
      
        let query = COLLETION_POSTS.whereField("ownerUid", isEqualTo: uid)
      
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("DEBUG: Failed to fetch Posts \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            var posts = documents.map({Post(postId: $0.documentID, dictonary: $0.data())})
    
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            completion(posts)
            
        }
    }
    
    static func fetchPost(withPostId postId: String, completion: @escaping(Post) -> Void) {
        COLLETION_POSTS.document(postId).getDocument { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let post = Post(postId: snapshot.documentID, dictonary: data)
            completion(post)
        }
    }
    
    static func deletePost( withPostId postId: String) {
        COLLETION_POSTS.document(postId).delete { error in
            
            if let error = error {
                print("DEBUG: Failed to delete Post \(error.localizedDescription)")
                return
            }
           
           
        }
        
    }
    
}
