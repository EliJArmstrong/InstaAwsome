//
//  CommentCell.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/20/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit


/// The Comment Cell for the table view for the post detail VC.
class CommentCell: UITableViewCell {
    
    @IBOutlet weak var commentLbl: UILabel! // Shows the comment for the comment
    @IBOutlet weak var userImage: Circleimage! // The users image for the user how commented.
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
