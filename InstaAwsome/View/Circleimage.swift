//
//  Circleimage.swift
//  Smack
//
//  Created by Eli Armstrong on 9/14/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse

@IBDesignable
class Circleimage: PFImageView {
    
    override func awakeFromNib() {
        setUpView()
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3.0{
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    func setUpView(){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }

}
