//
//  ViewController.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    let ref = Firebase(url: "https://changr.firebaseio.com/")

    @IBOutlet weak var currentUserLabel: UILabel!

    // MARK: UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: Actions
    
    @IBAction func menuButton(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print(appDelegate.centerContainer?.view)
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        ref.unauth()
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        appDelegate.window?.rootViewController = appDelegate.rootController
        appDelegate.window!.makeKeyAndVisible()

    }

}

