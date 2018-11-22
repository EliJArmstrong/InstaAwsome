//
//  UserImage.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/20/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import Foundation
import Parse

class UserImage: PFObject, PFSubclassing{
    
    @NSManaged var media : PFFileObject
    @NSManaged var user: PFUser
    
    static func parseClassName() -> String {
        return "UserImage"
    }

    static func postUserImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?){
        
        let userImg = UserImage()
        
        userImg.media = getPFFileFromImage(image: image)! // PFFile column type
        userImg.user = PFUser.current()! // Pointer column type that points to PFUser
        
        userImg.saveInBackground(block: completion)
    }
    
    static func getPFFileFromImage(image: UIImage?) -> PFFileObject? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = image.pngData() {
                return PFFileObject(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
