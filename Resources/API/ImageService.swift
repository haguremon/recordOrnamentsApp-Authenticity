//
//  ImageUploader.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-14.
//

import FirebaseStorage
import UIKit

// MARK: - イメージをアップロードする
struct ImageService {
    
    
    static func uploadImage(image: UIImage?, completion: @escaping (String) -> Void) {
        guard let image = image else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image\(filename)")

        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
        
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
        
                completion(imageUrl)
            }
        }
    }
    
}
