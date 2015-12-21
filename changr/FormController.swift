//
//  FormController.swift
//  changr
//
//  Created by Hamza Sheikh on 19/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class FormController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var beaconNameLabel: UILabel!
    
    var ref: Firebase!
    var beaconName = String()
    
    override func viewWillAppear(animated: Bool) {
        beaconNameLabel.text = beaconName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://changr.firebaseio.com/")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func completeProfile(sender: UIButton) {
        let usersRef = ref.childByAppendingPath("users")
        let currentUserRef = usersRef.childByAppendingPath("\(ref.authData.uid)")
        currentUserRef.updateChildValues(["beaconMinor": "\(beaconName)"])
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
