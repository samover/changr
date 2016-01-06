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
    let firebase = FirebaseWrapper()
    var appDelegate: AppDelegate!
    var ref: Firebase!
//    
//    @IBOutlet weak var profileImage: UIImageView!
//    @IBOutlet weak var fullNameLabel: UILabel!
//    @IBOutlet weak var emailLabel: UILabel!
//    @IBOutlet weak var dateOfBirthLabel: UILabel!
//    @IBOutlet weak var genderLabel: UILabel!

    // CONNECT TO FIREBASE DB





    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let usersRef = firebase.ref.childByAppendingPath("/users")
        print(usersRef.authData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: Actions
    @IBAction func menuButton(sender: AnyObject) {
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    
    @IBAction func logoutButton(sender: AnyObject) {
        firebase.ref.unauth()
        appDelegate.window?.rootViewController = appDelegate.rootController
        appDelegate.window!.makeKeyAndVisible()
    }

}
