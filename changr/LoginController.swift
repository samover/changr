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
                self.performSegueWithIdentifier("mainView", sender: self)
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
                    self.performSegueWithIdentifier("mainView", sender: self)

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

                    self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: { (error, authData) -> Void in
                        if error != nil {
                            self.errorMessage.text = "There was a problem with your sign in, please try again"
                            self.errorMessage.hidden = false

                        } else {
                            
                            let newUser = [
                                "provider": authData.provider,
                                "userType": self.userSelection,
                                "email": authData.providerData["email"] as? NSString as? String
                            ]
                            
                            self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                            print(self.userSelection)
                            if self.userSelection == "Donor" {
                                self.performSegueWithIdentifier("mainView", sender: self)
                            } else {
                                self.performSegueWithIdentifier("completeProfile", sender: self)

                            }
                            
                            
                        }
                    })
                        
                }

            }
            
        }
        
    }
    
//    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
//        print("user logged out")
//        self.emailTextField.text = ""
//        self.passwordTextField.text = ""
//
//        self.errorMessage.hidden = true
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
