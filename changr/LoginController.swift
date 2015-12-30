//
//  LoginController.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
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
        emailTextField.delegate = self
        passwordTextField.delegate = self
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        ref = appDelegate.ref

        self.userType.dataSource = self
        self.userType.delegate = self
        self.errorMessage.hidden = true
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
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
    
    // MARK: Authentication functions
    
    func resetAuthenticationForm() -> Void {
        self.hideErrorMessage()
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    func showErrorMessage(msg:String) -> Void {
        self.errorMessage.text = msg
        self.errorMessage.hidden = false
    }
    
    func hideErrorMessage() -> Void {
        self.errorMessage.hidden = true
    }
    
<<<<<<< Updated upstream
    func isInvalidInput() -> Bool {
        return emailTextField.text == "" || passwordTextField.text == ""
    }
    
    func loginUser() -> Void {
        ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: {
            (error, authData) in
            if error != nil {
                self.showErrorMessage("Username or password incorrect")
            } else {
                self.resetAuthenticationForm()
                self.isRegisteredUser(authData) ? self.delegateToCenterContainer() : self.updateProfile(authData)
=======
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
                            print(authData)
                            let newUser = [
                                "provider": authData.provider,
                                "userType": self.userSelection,
                                "email": authData.providerData["email"] as? NSString as? String
                            ]
                            
                            self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                            if self.userSelection == "Donor" {
                                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDelegate.window?.rootViewController = appDelegate.centerContainer
                                appDelegate.window!.makeKeyAndVisible()
                            } else {
                                self.performSegueWithIdentifier("completeProfile", sender: self)

                            }
                            
                            
                        }
                    })
                        
                }

>>>>>>> Stashed changes
            }
        })
    }
    
    func isRegisteredUser(authData: FAuthData) -> Bool {
        var isRegistered = false
        
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            isRegistered = snapshot.hasChild("users/\(authData.uid)")
        })
        return isRegistered
    }
    
    func updateProfile(authData: FAuthData) -> Void {
        let newUser = [
            "provider": authData.provider,
            "userType": self.userSelection,
            "email": authData.providerData["email"] as? NSString as? String,
            "beaconMinor": ""
        ]
        
        self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
        self.userSelection == "Donor" ? self.delegateToCenterContainer() : self.segueToCompleteProfile()
    }
    
    func delegateToCenterContainer() -> Void {
        self.appDelegate.window?.rootViewController = self.appDelegate.centerContainer
        self.appDelegate.window!.makeKeyAndVisible()
    }
    
    func segueToCompleteProfile() -> Void {
        self.performSegueWithIdentifier("completeProfile", sender: self)
    }
    
    func registerUser() -> Void {
        self.ref.createUser(self.emailTextField.text, password: self.passwordTextField.text) {
            (error: NSError!) in
            error == nil ? self.loginUser() : self.showErrorMessage("Please enter a valid password and email")
        }
    }

    // MARK: Actions
    @IBAction func loginButton(sender: AnyObject) {
        self.isInvalidInput() ? self.showErrorMessage("Please fill in a username and password") : loginUser()
    }

    
    @IBAction func signupButton(sender: AnyObject) {
        self.isInvalidInput() ? self.showErrorMessage("Please fill in a username and password") : registerUser()
    }
}
