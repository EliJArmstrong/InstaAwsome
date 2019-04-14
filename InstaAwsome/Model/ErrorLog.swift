//
//  ErrorLog.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/20/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import Foundation
import Parse

/// A table to store Error log message in the parse server.
class ErrorLog: PFObject, PFSubclassing{
    
    @NSManaged var user: PFUser // The user with the error.
    @NSManaged var errorMessage: String // The message of the error.
    
    
    /// The class name
    static func parseClassName() -> String {
        return "ErrorLog"
    }
    
    /// Posts the error message.
    static func postError(withMessage message: String, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let error = ErrorLog()
        
        // Add relevant fields to the object
        error.user = PFUser.current()! // Pointer column type that points to PFUser
        error.errorMessage = message

        
        // Save object (following function will save the object in Parse asynchronously)
        error.saveInBackground(block: completion)
    }
    
    
    
}
