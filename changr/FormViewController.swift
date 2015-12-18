//
//  FormViewController.swift
//  changr
//
//  Created by Hamza Sheikh on 18/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    @IBOutlet var beaconNameLabel: UILabel!
    
    var beaconName = String()
    
    override func viewWillAppear(animated: Bool) {
        beaconNameLabel.text = beaconName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
