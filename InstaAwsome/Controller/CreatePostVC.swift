//
//  CreatePostVC.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/18/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Lottie

class CreatePostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker =  UIImagePickerController()
    var pickerStyle = "Gallary"
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postBtn.isEnabled = false
        commentField.becomeFirstResponder()
        imagePicker.delegate = self
        animationView.animation = Animation.named("instagram")
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoPicker(tapGestureRecognizer:)))
        postImg.isUserInteractionEnabled = true
        postImg.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),
             NSAttributedString.Key.font: UIFont(name: "noteworthy-bold", size: 20)!]
        
        if pickerStyle == "Camera"{
            openCamera()
        } else{
            openGallary()
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
        postImg.image = editedImage
        dismiss(animated: true, completion: nil)
        commentField.becomeFirstResponder()
        postBtn.isEnabled = true
    }

    @IBAction func closeVC(_ sender: Any) {
        view.endEditing(true)
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
    
    
    @IBAction func postGram(_ sender: Any) {
        let image = postImg.image
        self.animationView.isHidden = false
        self.animationView.play()
        self.animationView.loopMode = .loop
        Post.postUserImage(image: image, withCaption: commentField.text ?? "") { (success, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("Awesome it posted")
                self.view.endEditing(true)
                self.animationView.stop()
                self.animationView.isHidden = true
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
