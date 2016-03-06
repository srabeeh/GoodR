//
//  ViewController.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-02-24.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var profileUserNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil{
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func fbButtonLoginPressed(sender: UIButton!){
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], handler: {
            (facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            
                DataService.dataService.REF_FIREBASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            
                            // To Do: Remove print
                            print("Logged in! \(authData)")
                            
                            
                            let user = ["provider": authData.provider!, "username":"\(self.profileUserNameField.text!)"]
                            DataService.dataService.createFirebaseUser(authData.uid, user: user)
                            
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        })
    }

    @IBAction func emailLogin(sender: UIButton){
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            if email.isEmail{
                
                DataService.dataService.REF_FIREBASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    print(error)
                    
                    if error.code == STATUS_USER_INVALID {
                        DataService.dataService.REF_FIREBASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                self.showErrorAlert("Problem creating account. Try something else", title: "Could not create account.")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.dataService.REF_FIREBASE.authUser(email, password: pwd, withCompletionBlock: { err, authData in
                                    
                                    let user = ["provider": authData.provider!, "profileusername": "Great Warrior"]
                                    DataService.dataService.createFirebaseUser(authData.uid, user: user)
                                })
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    } else {
                        if error.code == STATUS_PASSWORD_INVALID{
                           self.showErrorAlert("You have entered an invalid password for this account", title: "Invalid Password")
                        }
                        self.showErrorAlert("Please check your username or password", title: "Could not login")
                    }
                    
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
            } else {
                self.showErrorAlert("Please enter a valid email address.", title: "Invalid Email Address.")
            }
            
        } else {
            self.showErrorAlert("You must enter an email and a password", title: "Email and Password Required")
        }
    }

    
    func showErrorAlert(alertMessage: String, title: String){
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}