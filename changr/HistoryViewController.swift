//
//  HistoryViewController.swift
//  changr
//
//  Created by Samuel Overloop on 17/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    let firebase = FirebaseWrapper()
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var historySegmentedControl: UISegmentedControl!
    @IBOutlet weak var historyTableView: UITableView!
    
    let donationsList:[String] = ["Donation 1", "Donation 2"]
    let receiversList:[String] = ["Receiver 1", "Receiver 2"]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(historySegmentedControl.selectedSegmentIndex) {
            case 0:
                returnValue = donationsList.count
                break
            case 1:
                returnValue = receiversList.count
                break
            default:
                break
        }
        
        return returnValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let historyCell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath)
        
        switch(historySegmentedControl.selectedSegmentIndex) {
            case 0:
                historyCell.textLabel!.text = donationsList[indexPath.row]
                break
            case 1:
                historyCell.textLabel!.text = receiversList[indexPath.row]
                break
            default:
                break
        }
        
        return historyCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        historyTableView.reloadData()
    }
    
    @IBAction func menuButton(sender: AnyObject) {
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    @IBAction func logoutButton(sender: AnyObject) {
        firebase.ref.unauth()
        appDelegate.window?.rootViewController = appDelegate.rootController
        appDelegate.window!.makeKeyAndVisible()
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfileSelected" {
            if let destination = segue.destinationViewController as? ViewReceiverProfileController {
                if let _ = historyTableView.indexPathForSelectedRow?.row {
                    // Find Receiver from database by their name and retrieve their 'beaconMinor' value
                    let beaconMinor = "49281"
                    
                    destination.beaconData = "\(beaconMinor)"
                }
            }
        }
    }
}
