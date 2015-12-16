//
//  SignupController.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class SignupController: UIViewController {

    // MARK: Properties
    let ref = Firebase(url: "https://changr.firebaseio.com/")
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func signupButton(sender: AnyObject) {
        self.ref.createUser(self.emailTextField.text, password: self.passwordTextField.text) {
            (error: NSError!) in
            if error == nil {
                self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: { (error, authData) -> Void in
                    
                    let newUser = [
                        "provider": authData.provider,
                        "username": self.usernameTextField.text
                    ]
                    
                    self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                })
                print("test")
            }
        }
    }

    @IBAction func gotoLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
