//
//  ViewController.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    let ref = Firebase(url: "https://changr.firebaseio.com/")
    let locationManager = CLLocationManager()


    @IBOutlet weak var usernameLabel: UILabel!

    // MARK: UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    // MARK: Actions
    
    @IBAction func logoutButton(sender: AnyObject) {
        ref.unauth()
        print("User logged out")
        navigationController?.popViewControllerAnimated(true)
    }
    

}

