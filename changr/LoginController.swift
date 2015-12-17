//
//  LoginController.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userType: UIPickerView!
    @IBOutlet weak var errorMessage: UILabel!
    
    let ref = Firebase(url: "https://changr.firebaseio.com/")
    
    var pickerDataSource = ["Donor", "Receiver"]
    var userSelection = "Donor"
    
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userType.dataSource = self
        self.userType.delegate = self
        self.errorMessage.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.ref.unauth()
//                self.performSegueWithIdentifier("goto_welcome", sender: self)
            } else {
                // alert that User is not signed in
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Picker functions
    
    func numberOfComponentsInPickerView(userType: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(userType: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(userType: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(userType: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0)
        {
            print(pickerDataSource)
            self.userSelection = pickerDataSource[0]
            print(self.userSelection)
        }
        if(row == 1)
        {
            print(pickerDataSource)
            self.userSelection = pickerDataSource[1]
            print(self.userSelection)

        }
    }
    
    // MARK: Actions
    
    
    @IBAction func loginButton(sender: AnyObject) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            print("Make sure to enter in each textfield")
            self.errorMessage.text = "Please fill in a username and password"
            self.errorMessage.hidden = false
        } else {
            ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: { (error, authData) in
                if error != nil {
                    self.errorMessage.text = "Username or password incorrect"
                    self.errorMessage.hidden = false
                } else {
                    print("User successfully logged in")
                }
                
            })
        }
    }
    
    @IBAction func signupButton(sender: AnyObject) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            print("Make sure to enter in each textfield")
            self.errorMessage.text = "Please fill in a username and password"
            self.errorMessage.hidden = false
        } else {
            self.ref.createUser(self.emailTextField.text, password: self.passwordTextField.text) {
                (error: NSError!) in
                if error != nil {
                    print(error.description)
                    self.errorMessage.text = "Username or password incorrect"
                    self.errorMessage.hidden = false
                } else {
                    print("succesfull authentication")

                    self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: { (error, authData) -> Void in
                            let newUser = [
                                "provider": authData.provider,
                                "userType": self.userSelection
                            ]
                            
                            self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                            
                        })
                }

            }
            
        }
        
    }
    
//    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
//        
//    }
    
    
    // MARK: - Navigation
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
