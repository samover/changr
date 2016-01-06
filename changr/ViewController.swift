//
//  ViewController.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

// NOTE TO SELF: Do not use appdelegate for firebase operation
// rather have a model that can be mocked 

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var appDelegate: AppDelegate!
    let firebase = FirebaseWrapper()
    
    var welcomeLabel: UILabel!
    var descriptionLabel: UILabel!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
        welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to Changr"
        welcomeLabel.font = UIFont.systemFontOfSize(25)
        welcomeLabel.sizeToFit()
        welcomeLabel.center = CGPoint(x: 100, y: 40)
        view.addSubview(welcomeLabel)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.welcomeLabel.center = CGPoint(x: 100, y:40 + 200)
            }, completion: nil)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Changr is an app to help those who are homeless..."
        descriptionLabel.font = UIFont.boldSystemFontOfSize(15)
        descriptionLabel.sizeToFit()
        descriptionLabel.center = CGPoint(x: 200, y: 90)
        view.addSubview(descriptionLabel)
        
        descriptionLabel.alpha = 0
        
        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.descriptionLabel.center = CGPoint(x: 200, y: 90 + 200)
            self.descriptionLabel.alpha = 1
            }, completion: nil)
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

