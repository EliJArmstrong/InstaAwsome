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
import Lottie

class PostVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var posts = [Post]()
    var sendString: String!
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var animationView: LOTAnimationView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tabBarController?.tabBar.isHidden = false
        animationView.setAnimation(named: "instagram")
        animationView.loopAnimation = true
        animationView.play()
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
//        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
//        {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                    self.sendString = "Camera"
                    self.performSegue(withIdentifier: "CreatePostSegue", sender: nil)
                } else{
                    let alert = UIAlertController(title: "Sorry", message: "You do not have a camera 📸 available 😢", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.sendString = "Gallery"
                self.performSegue(withIdentifier: "CreatePostSegue", sender: nil)
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
//        } else{
//            self.sendString = "Gallery"
//            self.performSegue(withIdentifier: "CreatePostSegue", sender: nil)
//        }
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
                self.animationView.stop()
                self.animationView.isHidden = true
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
                detailVC.post = posts[indexPath.section]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    // Table view controls
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("\n \(posts[section].count) \n")
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 75))
        headerView.backgroundColor = UIColor(white: 0, alpha: 0)
        
        let profileView = Circleimage(frame: CGRect(x: 10, y: 25, width: 50, height: 50))
        profileView.cornerRadius = 15.0
        profileView.layer.borderColor =  UIColor(white: 1, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 3;
        
        // Set the avatar
        let imageQuery = UserImage.query()
        imageQuery?.whereKey("user", equalTo: posts[section].author)
        imageQuery?.includeKey("media")
        imageQuery?.getFirstObjectInBackground(block: { (queriedImage, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                let image = queriedImage as! UserImage
                profileView.file = image.media
                profileView.loadInBackground()
            }
        })

        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        let label = UILabel(frame: CGRect(x: 65, y: 10, width: 320, height: 50))
        label.textColor = UIColor(white: 1, alpha: 1)
        let postDate = posts[section].createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        do {
            let poster = try PFQuery.getUserObject(withId: posts[section].author.objectId!)
            label.text = "*\(poster.username!)* \(dateFormatter.string(from: postDate!))"
        } catch {}
        //label.text = " \(dateFormatter.string(from: postDate!))"
        label.font = UIFont(name: "Helvetica Neue", size: 17)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.postImg.file = posts[indexPath.section].media
        cell.postImg.loadInBackground()
        cell.numberOfLikesLbl.text = String(posts[indexPath.section].likesCount)
        cell.postID = posts[indexPath.section].objectId
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPosts()
    }

}
