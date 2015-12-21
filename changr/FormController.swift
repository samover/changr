//
//  FormController.swift
//  changr
//
//  Created by Hamza Sheikh on 19/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class FormController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderField: UISegmentedControl!
    @IBOutlet weak var dayField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var beaconNameLabel: UILabel!
    
    
    var ref: Firebase!
    var beaconName = String()
    
    override func viewWillAppear(animated: Bool) {
        beaconNameLabel.text = beaconName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://changr.firebaseio.com/")
        nameTextField.delegate = self
        dayField.delegate = self
        monthField.delegate = self
        yearField.delegate = self
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    // MARK: Actions
    
    @IBAction func completeProfile(sender: UIButton) {
        let usersRef = ref.childByAppendingPath("users")
        let currentUserRef = usersRef.childByAppendingPath("\(ref.authData.uid)")
        currentUserRef.updateChildValues(["beaconMinor": "\(beaconName)"])
    }
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
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
