//
//  ProfileViewController.swift
//  changr
//
//  Created by Samuel Overloop on 17/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameDisplay: UILabel!
    @IBOutlet weak var emailDisplay: UILabel!
    @IBOutlet weak var dateOfBirthDisplay: UILabel!
    @IBOutlet weak var genderDisplay: UILabel!
    @IBOutlet weak var accountBalanceDisplay: UILabel!


    
    let firebase = FirebaseWrapper()
    var appDelegate: AppDelegate!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


        getCurrentUserInfoFromDBAndDisplayData()
    }

    func getCurrentUserInfoFromDBAndDisplayData() {
         let userRef = Firebase(url: "https://changr.firebaseio.com/users/\(firebase.ref.authData.uid)")

         userRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            let currentUser = snapshot.value
            self.displayReceiverProfileImage((currentUser["profileImage"] as? String)!)
            self.fullNameDisplay.text = (currentUser["fullName"] as! String)
            self.emailDisplay.text = "EMAIL: \(currentUser["email"] as! String)"
            self.dateOfBirthDisplay.text = "DOB: \(currentUser["dateOfBirth"] as! String)"
            self.genderDisplay.text = "GENDER: \(currentUser["gender"] as! String)"
        })
        self.accountBalanceDisplay.text = "ACC. BALANCE: £5"
    }

    // This decodes the base64string into an UIImage:

    func displayReceiverProfileImage(imageString: String) {
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        self.profileImage.image = decodedImage
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 1.0
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 6.0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: Actions
    @IBAction func menuButton(sender: AnyObject) {
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    @IBAction func signOutButton(sender: AnyObject) {
        firebase.ref.unauth()
        appDelegate.window?.rootViewController = appDelegate.rootController
        appDelegate.window!.makeKeyAndVisible()
    }

}
