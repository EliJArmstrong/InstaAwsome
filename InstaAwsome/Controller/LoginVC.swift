//
//  ViewController.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/16/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse
import Lottie

class LoginVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var animateView: LOTAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimate()
        let tap = UITapGestureRecognizer(target: self, action: #selector(startAnimate))
        animateView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func startAnimate(){
        animateView.setAnimation(named: "instagram")
        animateView.play()

    }

    @IBAction func signInPressed(_ sender: Any) {
        loginUser()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        registerUser()
    }
    
    func loginUser() {
        
        let username = userNameField.text ?? ""
        let password = passwordField.text ?? ""

        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
    }
    
    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        
        //call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                // make an alert for the error for the user and make a log for dev team.
                ErrorLog.postError(withMessage: error.localizedDescription, withCompletion: { (success, error) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                })
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                UserImage.postUserImage(image: UIImage(named: "image_placeholder"), withCompletion: nil)
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
    }
}

