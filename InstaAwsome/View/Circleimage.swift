//
//  Circleimage.swift
//  Smack
//
//  Created by Eli Armstrong on 9/14/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse

/// IBDesinable makes it so that the story board will update it's views to show the this class.
@IBDesignable

/// Circle image class inheritance from PFImageView
class Circleimage: PFImageView {
    
    
    /// This is like this main function or the view did load function in a view controller.
    override func awakeFromNib() {
        setUpView()
    }
    
    
    /// The corner radius of the image.
    @IBInspectable var cornerRadius: CGFloat = 3.0{
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    /// Sets up the radius for the image and insures the clips to bounds to true.
    func setUpView(){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    // When a class uses @IBDesignable this is the function is the link to the interface builder to show the properities of the class.
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }

}
