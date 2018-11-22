//
//  Comment.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/21/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import Foundation
import Parse

class Comment: PFObject, PFSubclassing{
    
    @NSManaged var author: PFUser
    @NSManaged var comment: String
    @NSManaged var post: Post
    
    static func parseClassName() -> String {
        return "Comment"
    }
    
    static func postComment(post: Post, comment: String, withCompletion completion: PFBooleanResultBlock?){
        let commentObject = Comment()
        
        commentObject.author = PFUser.current()!
        commentObject.comment = comment
        commentObject.post = post
        
        commentObject.saveInBackground(block: completion)
    }
    
    
    
}
