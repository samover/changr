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
        currentUserLabel.text = "Logged in as \(ref.authData.providerData["email"]!)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    // MARK: Actions
    
    @IBAction func showMenu(sender: UIBarButtonItem) {
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        ref.unauth()
        print("User logged out")
        navigationController?.popViewControllerAnimated(true)
    }
    

}

