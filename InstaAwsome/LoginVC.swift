//
//  ViewController.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/16/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signInPressed(_ sender: Any) {
        loginUser()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        registerUser()
    }
    
    func logoutUser(){
        
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                print("user has been loged out.")
            }
        }
    }
    
    
    
    func loginUser() {
        
        let username = userNameField.text ?? ""
        let password = passwordField.text ?? ""

        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
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
        //newUser.email = passwordField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success{
                print("User Registered successfully")
                // manually segue to logged in view
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            } else{
                if let error = error{
                    print(error.localizedDescription)
                }
            }
        }
        
        // call sign up function on the object
//        newUser.signUpInBackground { (success: Bool, error: Error?) in
//            if let error = error {
//                print(error.localizedDescription)
//                // make an alert for the error for the user and make a log for dev team.
//            } else {
//                print("User Registered successfully")
//                // manually segue to logged in view
//            }
//        }
    }
}

