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
    var appDelegate: AppDelegate!
    var ref: Firebase!
    var pickerDataSource = ["Donor", "Receiver"]
    var userSelection = "Donor"
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userType: UIPickerView!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        ref = appDelegate.ref
        self.userType.dataSource = self
        self.userType.delegate = self
        self.errorMessage.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        self.userSelection = row == 0 ? pickerDataSource[0] : pickerDataSource[1]
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
                    self.appDelegate.window?.rootViewController = self.appDelegate.centerContainer
                    self.appDelegate.window!.makeKeyAndVisible()

                }
                
            })
        }
    }

    
    @IBAction func signupButton(sender: AnyObject) {
        if emailTextField.text == "" || passwordTextField.text == "" {
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
                            if self.userSelection == "Donor" {
                                self.appDelegate.window?.rootViewController = self.appDelegate.centerContainer
                                self.appDelegate.window!.makeKeyAndVisible()
                            } else {
                                self.performSegueWithIdentifier("completeProfile", sender: self)

                            }
                            
                        }
                    })
                        
                }

            }
            
        }
        
    }

}
