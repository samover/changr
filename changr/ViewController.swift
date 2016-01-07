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
    
        // Welcome Label:
        welcomeLabel = UILabel(frame: CGRectMake(0, 0, 350, 350))
        welcomeLabel.text = "Welcome to Changr!"
        welcomeLabel.font = UIFont.boldSystemFontOfSize(27)
        welcomeLabel.center = CGPointMake(100, 40)
        welcomeLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(welcomeLabel)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.welcomeLabel.center = CGPointMake(160, 240)
            }, completion: nil)
        
        // Description Label:
        descriptionLabel = UILabel(frame: CGRectMake(0, 0, 270, 450))
        descriptionLabel.text = "Changr is an app to help those who are homeless..."
        descriptionLabel.font = UIFont.italicSystemFontOfSize(18)
        descriptionLabel.center = CGPointMake(200, 90)
        descriptionLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        descriptionLabel.alpha = 0
        
        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.descriptionLabel.center = CGPointMake(160, 290)
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

