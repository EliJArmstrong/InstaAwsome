//
//  ImageVC.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/16/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

// CreatePostSegue

import UIKit
import Parse

class PostVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var posts = [Post]()
    var sendString: String!
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),
             NSAttributedString.Key.font: UIFont(name: "noteworthy-bold", size: 20)!]
        fetchPosts()
    }
    
    @IBAction func LogoutPressed(_ sender: Any) {
        logoutUser()
        
    }
    
    func logoutUser(){
        
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error{
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                print(error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
            } else{
                print("user has been loged out.")
                self.performSegue(withIdentifier: "LoginVC", sender: nil)
            }
        }
    }
    

    @IBAction func buttonOnClick(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.sendString = "Camera"
                self.performSegue(withIdentifier: "CreatePostSegue", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.sendString = "Gallery"
                self.performSegue(withIdentifier: "CreatePostSegue", sender: nil)
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else{
            self.sendString = "Gallery"
            self.performSegue(withIdentifier: "CreatePostSegue", sender: nil)
        }
    }
    
    @objc func fetchPosts(){
        let query = Post.query()
        query?.selectKeys(["author", "createdAt", "media", "likesCount", "caption", "commentsCount"])
        query?.order(byDescending: "createdAt")
        query?.limit = 20
        query?.findObjectsInBackground(block: { (posts, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                self.posts = posts as! [Post]
                //print(posts!)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePostSegue"{
            let navVC = segue.destination as? UINavigationController
            let createPostVC = navVC?.viewControllers.first as! CreatePostVC
            createPostVC.pickerStyle = self.sendString
        } else if segue.identifier == "detailSegue"{
            let detailVC = segue.destination as! DetailsVC
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                detailVC.post = posts[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.postImg.file = posts[indexPath.row].media
        cell.postImg.loadInBackground()
        cell.numberOfLikesLbl.text = String(posts[indexPath.row].likesCount)
        cell.postID = posts[indexPath.row].objectId
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPosts()
    }

}
