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


/// This class hold the properities ofthe table view cell; PostCell
class PostCell: UITableViewCell {

    @IBOutlet weak var likeBtn: LOTAnimationView! // The like button. Its not really a button is an animated view that is Programmatically made into a button.
    @IBOutlet weak var postImg: PFImageView! // The image of the post.
    @IBOutlet weak var numberOfLikesLbl: UILabel! // A UILabel to display the like count.
    var postID : String! // The post ID to easily access the associated post.
    
    
    /// Adds the button functionally to the LOTAnimationView and set the animation.
    override func awakeFromNib() {
        super.awakeFromNib()
        likeBtn.setAnimation(named: "like")
        likeBtn.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeBtnPressed(_:)))
        likeBtn.addGestureRecognizer(tap)
    }

    /// This just makes sure that the background is clear when the cell is tapped.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = backgroundView
    }

    // This is the function that runs when likeBtn (LOTAnimationView) is tapped.
    // This will send the updated like count to the parse server.
    // This will also update the like count label and play the animation.
    @objc func likeBtnPressed(_ sender: Any) {
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: postID) { (post, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                self.likeBtn.play()
                post?["likesCount"] = Int(self.numberOfLikesLbl.text!)! + 1
                post?.saveInBackground()
                self.numberOfLikesLbl.text = String(Int(self.numberOfLikesLbl.text!)! + 1)
            }
        }
    }
}
