//
//  LoginController.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    var appDelegate: AppDelegate!
    var firebase: FirebaseWrapper!
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
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
        firebase = appDelegate.firebase
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
    
    func isInvalidInput() -> Bool {
        return emailTextField.text == "" || passwordTextField.text == ""
    }
    
    func loginUser(newUser: Bool) -> Void {
        firebase.ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: {
            (error, authData) in
            if error != nil {
                self.showErrorMessage("Username or password incorrect")
            } else {
                self.firebase.authRef().observeSingleEventOfType(.Value, withBlock: { snapshot in
                    print(snapshot.value)
                    self.firebase.userData = snapshot.value as? NSDictionary
                    self.resetAuthenticationForm()
                    newUser == true ? self.updateProfile(authData) : self.delegateToCenterContainer()
                })
            }
        })
    }
    
    func updateProfile(authData: FAuthData) -> Void {
        let email = authData.providerData["email"] as? NSString as? String
        
        let newDonor = [
            "provider": authData.provider,
            "userType": self.userSelection,
            "email": email,
            "beaconHistory": "",
            "beaconMinor": ""
        ]
        let newReceiver = [
            "provider": authData.provider,
            "userType": self.userSelection,
            "email": email,
            "beaconMinor": ""
        ]
        
        if self.userSelection == "Donor" {
            firebase.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newDonor)
            self.delegateToCenterContainer()
        }  else {
            firebase.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newReceiver)
            self.segueToCompleteProfile()
        }
    }
    
    func delegateToCenterContainer() -> Void {
        self.appDelegate.window?.rootViewController = self.appDelegate.centerContainer
        self.appDelegate.window!.makeKeyAndVisible()
    }
    
    func segueToCompleteProfile() -> Void {
        self.performSegueWithIdentifier("completeProfile", sender: self)
    }
    
    func registerUser() -> Void {
        print(firebase.ref)
        firebase.ref.createUser(self.emailTextField.text, password: self.passwordTextField.text) {
            (error: NSError!) in
            if(error == nil) {
                self.loginUser(true)
            } else {
                self.showErrorMessage("Please enter a valid password and email")
            }
        }
    }

    // MARK: Actions
    @IBAction func loginButton(sender: AnyObject) {
        self.isInvalidInput() ? self.showErrorMessage("Please fill in a username and password") : loginUser(false)
    }

    
    @IBAction func signupButton(sender: AnyObject) {
        self.isInvalidInput() ? self.showErrorMessage("Please fill in a username and password") : registerUser()
    }
}
