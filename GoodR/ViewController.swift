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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil{
            self.performSegueWithIdentifier(KEY_LOGGED_IN, sender: nil)
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
                            print("Logged in! \(authData)")
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            self.performSegueWithIdentifier(KEY_LOGGED_IN, sender: nil)
                    }
                })
            }
        })
    }

    @IBAction func Login(sender: UIButton){
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd !="" {
            
        }
    }
    
    func showErrorAlert(message: String, title: String){
        
    }
    
}

