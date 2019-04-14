//
//  Comment.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/21/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import Foundation
import Parse

// The Comment of a Post
class Comment: PFObject, PFSubclassing{
    
    @NSManaged var author: PFUser // The user that Post the comment
    @NSManaged var comment: String // The message (comment) for the post.
    @NSManaged var post: Post // The Post the comment is for.
    
    /// The name of the object for the parse server
    static func parseClassName() -> String {
        return "Comment"
    }
    
    // Posts the comment to the parse sever.
    static func postComment(post: Post, comment: String, withCompletion completion: PFBooleanResultBlock?){
        let commentObject = Comment()
        
        commentObject.author = PFUser.current()!
        commentObject.comment = comment
        commentObject.post = post
        
        commentObject.saveInBackground(block: completion)
    }
    
    
    
}
