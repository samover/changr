//
//  HistoryViewController.swift
//  changr
//
//  Created by Samuel Overloop on 17/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    var firebase = FirebaseWrapper()
    var appDelegate: AppDelegate!
    var beaconHistoryList = [NSDictionary]()
    
    @IBOutlet weak var historySegmentedControl: UISegmentedControl!
    @IBOutlet weak var historyTableView: UITableView!
    
    let donationsList:[String] = ["Donation 1", "Donation 2"]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        beaconHistoryList = [NSDictionary]()
        
        loadDataFromFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(historySegmentedControl.selectedSegmentIndex) {
            case 0: // Donations
                returnValue = donationsList.count
                break
            case 1: // Receivers
                returnValue = beaconHistoryList.count
                break
            default:
                break
        }
        
        return returnValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let historyCell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath)
        
        switch(historySegmentedControl.selectedSegmentIndex) {
            case 0: // Donations
                historyCell.textLabel!.text = donationsList[indexPath.row]
                break
            case 1: // Receivers
                configureCell(historyCell, indexPath: indexPath)
                break
            default:
                break
        }
        
        return historyCell
    }
    
    // MARK: Configure Cell
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let dict = beaconHistoryList[indexPath.row]
        let firebaseReceiver = Firebase(url:"https://changr.firebaseio.com/users/\(dict["uid"])")
        
        cell.textLabel?.text = firebaseReceiver.ref.valueForKey("fullName") as? String
        cell.detailTextLabel?.text = dict["time"] as? String
        
        let base64String = firebaseReceiver.ref.valueForKey("profileImage") as? String
        populateImage(cell, imageString: base64String!)
    }
    
    // MARK: Populate Image
    
    func populateImage(cell:UITableViewCell, imageString: String) {

        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        let decodedImage = UIImage(data: decodedData!)
        
        cell.imageView!.image = decodedImage
        
    }
    
    // MARK: Load data from Firebase
    
    func loadDataFromFirebase() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let currentDonorBeaconHistoryRef = firebase.ref.childByAppendingPath("\(firebase.ref.authData)/beaconHistory")
        
        currentDonorBeaconHistoryRef.observeEventType(.Value, withBlock: { snapshot in
            var receiversList = [NSDictionary]()
            
            for item in snapshot.children {
                let receiver = item as! FDataSnapshot
                let receiversInfo = receiver.value as! NSDictionary
                receiversList.append(receiversInfo)
            }
            
            self.beaconHistoryList = receiversList
            self.historyTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
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
