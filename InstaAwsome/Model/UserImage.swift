//
//  UserImage.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/20/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import Foundation
import Parse

/// The users image. I desided to make the users image it's own table due to my SQL class teaching me that is method of storing images can be more efficient.
class UserImage: PFObject, PFSubclassing{
    
    @NSManaged var media : PFFileObject // The users image.
    @NSManaged var user: PFUser // The user the image is linked to.
    
    
    /// The name of the table (object) in the parse server.
    static func parseClassName() -> String {
        return "UserImage"
    }

    /// Posts the users image.
    static func postUserImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?){
        
        let userImg = UserImage()
        
        userImg.media = getPFFileFromImage(image: image)! // PFFile column type
        userImg.user = PFUser.current()! // Pointer column type that points to PFUser
        
        userImg.saveInBackground(block: completion)
    }
    
    
    /// This function turns a UIImage to a PFFileObject.
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
