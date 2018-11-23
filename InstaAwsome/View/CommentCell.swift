//
//  CommentCell.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/20/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
//import Parse

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var userImage: Circleimage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
