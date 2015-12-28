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
        print(ref)
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
    
    func isInvalidInput() -> Bool {
        print(emailTextField.text == "" || passwordTextField.text == "")
        return emailTextField.text == "" || passwordTextField.text == ""
    }
    
    func loginUser() -> Void {
        ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: {
            (error, authData) in
            if error != nil {
                self.showErrorMessage("Username or password incorrect")
            } else {
                self.resetAuthenticationForm()
                print("Login User function")
                self.isRegisteredUser(authData) ? self.delegateToCenterContainer() : self.updateProfile(authData)
            }
        })
    }
    
    func isRegisteredUser(authData: FAuthData) -> Bool {
        var isRegistered = false
        ref = Firebase(url: "https://changr.firebaseio.com/users")

        print("isRegisterduser function")
        print(ref.childByAutoId())
        ref.observeEventType(.Value, withBlock: {
            snapshot in
                print("From withing the snapshot: the key:")
                print(snapshot.key)
                print("And then the value:")
                print(snapshot.value)
//            print("We are in the snaphsot")
//            print(snapshot.hasChildren())
//            print(snapshot.childrenCount)
            isRegistered = snapshot.hasChild("users/\(authData.uid)")
            print(isRegistered)
        })
        print(isRegistered)
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
        print("function: Register User")
        self.ref.createUser(self.emailTextField.text, password: self.passwordTextField.text) {
            (error: NSError!) in
            print("Inside create user")
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
