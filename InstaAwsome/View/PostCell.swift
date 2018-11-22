//
//  PostCell.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/18/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse
import Lottie

class PostCell: UITableViewCell {

    @IBOutlet weak var postImg: PFImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var numberOfLikesLbl: UILabel!
    var postID : String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = backgroundView
        // Configure the view for the selected state
    }

    @IBAction func likeBtnPressed(_ sender: Any) {
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: postID) { (post, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                post?["likesCount"] = Int(self.numberOfLikesLbl.text!)! + 1
                post?.saveInBackground()
                self.numberOfLikesLbl.text = String(Int(self.numberOfLikesLbl.text!)! + 1)
            }
        }
    }
}
