//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/1.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool) {
        if DZDUser.currentUser() != nil {
            performSegueWithIdentifier(DZDSegue.ShowGroupViewChart, sender: self)
        }
    }
    
    @IBAction func login() {
        if usernameTextField.text.isEmpty || passwordTextField.text.isEmpty {
            DZDUtility.showAlert("Please input username and password!", controller: self)
            return
        }
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        // start spinner
        spinner.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        // login
        DZDUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
            // stop spinner
            self.spinner.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
                self.performSegueWithIdentifier(DZDSegue.ShowGroupViewChart, sender: self)
            } else {
                DZDUtility.showAlert(error!.userInfo?["error"] as? String, controller: self)
            }
        })
    }

}