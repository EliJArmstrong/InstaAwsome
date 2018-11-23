//
//  DetailsVC.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/19/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse

class DetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var post : Post!
    var comments = [Comment]()
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var detailImg: PFImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postCommentBtn: UIButton!
    @IBOutlet weak var commentField: UITextField!
    
    var isTyping = false
    var offset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        tabBarController?.tabBar.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        detailImg.file = post.media
        detailImg.loadInBackground()
        caption.text = post.caption
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateLbl.text = dateFormatter.string(from: post.createdAt!)
        postCommentBtn.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        fetchComments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func fetchComments(){
        let commentQuery = Comment.query()
        commentQuery?.selectKeys(["author", "comment", "poster"])
        commentQuery?.whereKey("post", equalTo: post)
        commentQuery?.order(byDescending: "createdAt")
        commentQuery?.findObjectsInBackground(block: { (queriedComments, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                self.comments = queriedComments as! [Comment]
                print(self.comments)
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(comments.count)
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        print("\(indexPath.row) \(cell.commentLbl.text!)" )
        let imageQuery = UserImage.query()
        imageQuery?.whereKey("user", equalTo: comments[indexPath.row].author)
        imageQuery?.includeKey("media")
        imageQuery?.getFirstObjectInBackground(block: { (queriedImage, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                let image = queriedImage as! UserImage
                cell.userImage.file = image.media
                cell.userImage.loadInBackground()
            }
        })
        do {
            let poster = try PFQuery.getUserObject(withId: comments[indexPath.row].author.objectId!)
            cell.commentLbl.text = "*\(poster.username!)* \(comments[indexPath.row].comment)"
        } catch {}
        
        return cell
    }
    
    @IBAction func typeingmessage(_ sender: Any) {
        if commentField.text == ""{
            isTyping = false
            postCommentBtn.isHidden = true
        } else{
            if isTyping == false{
                postCommentBtn.isHidden = false
            }
            isTyping = true
        }
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    @IBAction func commentBtnPressed(_ sender: Any) {
        Comment.postComment(post: post, comment: commentField.text!, withCompletion: nil)
        let updatePost = Post.query()
        updatePost?.getObjectInBackground(withId: post.objectId!, block: { (myPost, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                let myPost = myPost as! Post
                myPost.incrementKey("commentsCount")
                myPost.saveInBackground()
                self.commentField.resignFirstResponder()
                self.commentField.text = ""
                self.fetchComments()
            }
        })
    }
    

}
