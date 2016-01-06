//
//  FormController.swift
//  changr
//
//  Created by Hamza Sheikh on 19/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import Firebase

class FormController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderField: UISegmentedControl!
    @IBOutlet weak var dayField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var beaconNameLabel: UILabel!
    @IBOutlet weak var completeProfileButton: UIButton!
    
    var ref: Firebase!
    let defaults = NSUserDefaults.standardUserDefaults()
    var beaconName = String()
    var gender = String()
    var data: NSData = NSData()
    var base64String: NSString!
    var appDelegate: AppDelegate!
   
    override func viewWillAppear(animated: Bool) {
        beaconNameLabel.text = "Beacon Selected: \(beaconName)"
        nameTextField.text = defaults.stringForKey("fullName")
        dayField.text = defaults.stringForKey("calendarDay")
        monthField.text = defaults.stringForKey("calendarMonth")
        yearField.text = defaults.stringForKey("calendarYear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://changr.firebaseio.com/")
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
        
        nameTextField.delegate = self
        dayField.delegate = self
        monthField.delegate = self
        yearField.delegate = self
        
        completeProfileButton.enabled = false
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // To set the default values for current user in case they select beacon after entering their name and/or DOB
        defaults.setObject(nameTextField.text, forKey: "fullName")
        defaults.setObject(dayField.text, forKey: "calendarDay")
        defaults.setObject(monthField.text, forKey: "calendarMonth")
        defaults.setObject(yearField.text, forKey: "calendarYear")
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
        // Make the Complete Profile button enabled
        completeProfileButton.enabled = true
    }
    
    // MARK: Actions
    
    @IBAction func completeProfile(sender: UIButton) {
        let fullName = defaults.stringForKey("fullName") as String!
        let day = defaults.stringForKey("calendarDay") as String!
        let month = defaults.stringForKey("calendarMonth") as String!
        let year = defaults.stringForKey("calendarYear") as String!
        let dateOfBirth = "\(day)/\(month)/\(year)" as String!
        setGender()
        convertImage()
        
        let updateUser = [
            "beaconMinor": "\(beaconName)",
            "fullName": "\(fullName)",
            "dateOfBirth": "\(dateOfBirth)",
            "gender": "\(gender)",
            "profileImage": self.base64String
        ]
        
        let usersRef = ref.childByAppendingPath("users")
        let currentUserRef = usersRef.childByAppendingPath("\(ref.authData.uid)")
        currentUserRef.updateChildValues(updateUser)
        
        clearUserDefaults()
        self.appDelegate.window?.rootViewController = self.appDelegate.centerContainer
        self.appDelegate.window!.makeKeyAndVisible()
    }
    
    func setGender() {
        if genderField.selectedSegmentIndex == 0 {
            gender = "Male"
        } else if genderField.selectedSegmentIndex == 1 {
            gender = "Female"
        }
    }
    
    // This converts the profile image into an encoded string to be stored in Firebase:
    
    func convertImage() {
        if let image = photoImageView.image { data = UIImageJPEGRepresentation(image, 0.1)! }
        self.base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    // This clears NSUserDefaults:
    
    func clearUserDefaults() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
    }
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        dayField.resignFirstResponder()
        monthField.resignFirstResponder()
        yearField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
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
