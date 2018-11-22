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
    
    func setUpView(){
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }

}
