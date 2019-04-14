//
//  ProfileVC.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/20/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var posts = [Post]()
    
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var userImage: Circleimage!
    var imagePicker =  UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        collectView.delegate = self
        collectView.dataSource = self
        tabBarController?.tabBar.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoPicker(tapGestureRecognizer:)))
        userImage.addGestureRecognizer(tap)
        userImage.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),
             NSAttributedString.Key.font: UIFont(name: "noteworthy-bold", size: 20)!]
        UserNameLbl.text = PFUser.current()?.username
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView.dequeueReusableCell(withReuseIdentifier: "UserImageCell", for: indexPath) as! UserPostImageCell
        cell.image.file = posts[indexPath.item].media
        cell.image.loadInBackground()
        return cell
    }
    
    func fetchData(){
        let postsQuery = Post.query()
        postsQuery?.whereKey("author", equalTo: PFUser.current()!)
        postsQuery?.selectKeys(["author", "createdAt", "media", "likesCount", "caption", "commentsCount"])
        postsQuery?.order(byDescending: "createdAt")
        postsQuery?.findObjectsInBackground(block: { (posts, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                self.posts = posts as! [Post]
                self.collectView.reloadData()
                //self.refreshControl.endRefreshing()
            }
        })
        let userImageQuery = UserImage.query()
        userImageQuery?.whereKey("user", equalTo: PFUser.current()!)
        userImageQuery?.includeKey("media")
        userImageQuery?.order(byDescending: "createdAt")
        userImageQuery?.getFirstObjectInBackground(block: { (user, error) in
            if let error = error{
                print("Cant get object" + error.localizedDescription)
            } else{
                let user = user as! UserImage
                self.userImage.file = user.media
                self.userImage.loadInBackground()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let detailVC = segue.destination as! DetailsVC
            let cell = sender as! UICollectionViewCell
            if let indexPath = collectView.indexPath(for: cell){
                detailVC.post = posts[indexPath.item]
            }
    }
    
    @objc func photoPicker(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else{
            self.openGallary()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        userImage.image = editedImage
        let query = UserImage.query()
        query?.whereKey("user", equalTo: PFUser.current()!)
        query?.getFirstObjectInBackground(block: { (image, error) in
            if let error = error {
                print(error.localizedDescription)
            } else{
                let image = image as! UserImage
                image.media = UserImage.getPFFileFromImage(image: self.userImage.image)!
                image.saveInBackground(block: { (Bool, error) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                })
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

}
