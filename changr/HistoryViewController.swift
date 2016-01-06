//
//  HistoryViewController.swift
//  changr
//
//  Created by Samuel Overloop on 17/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import Firebase
import DateTools

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    var firebase = FirebaseWrapper()
    var appDelegate: AppDelegate!
    var beaconHistoryList = [NSDictionary]()
    
    @IBOutlet weak var historySegmentedControl: UISegmentedControl!
    @IBOutlet weak var historyTableView: UITableView!
   
    let donationsList:[String] = ["Donation 1", "Donation 2", "Donation 3"]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        loadDataFromFirebase()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        beaconHistoryList = [NSDictionary]()
        loadDataFromFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Load data from Firebase
    
    func loadDataFromFirebase() {
        
        let currentDonorBeaconHistoryRef = firebase.ref.childByAppendingPath("users/\(firebase.ref.authData.uid)/beaconHistory")
        
        currentDonorBeaconHistoryRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var receiversList = [NSDictionary]()
            
            for item in snapshot.children {
                let receiver = item as! FDataSnapshot
                let receiversInfo = receiver.value as! NSDictionary
                receiversList.append(receiversInfo)
            }
            
            self.beaconHistoryList = receiversList
            self.historyTableView.reloadData()
        })
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
    
    // MARK: Create the Cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let historyCell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath)
        
        switch(historySegmentedControl.selectedSegmentIndex) {
            case 0: // Donations
                historyCell!.textLabel!.text = donationsList[indexPath.row]
                historyCell!.detailTextLabel?.text = "Donated on 01/01/2016"
                break
            case 1: // Receivers
                configureCell(historyCell!, indexPath: indexPath)
                break
            default:
                break
        }
        
        return historyCell!
    }
    
    // MARK: Configure Cell
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let dict = beaconHistoryList[indexPath.row]
        
        let firebaseReceiver = Firebase(url: "https://changr.firebaseio.com/users/\(dict["uid"]!)")
        
        firebaseReceiver.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let value = snapshot.value as! NSDictionary
                       
            cell.textLabel?.text = value["fullName"] as? String
            cell.detailTextLabel?.text = dict["time"] as? String
            
            let base64String = value["profileImage"] as? String
            self.populateImage(cell, imageString: base64String!)
        })
    }
    
    // MARK: Populate Image
    
    func populateImage(cell:UITableViewCell, imageString: String) {
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        cell.imageView!.image = decodedImage
        cell.imageView!.layer.cornerRadius = 28
        cell.imageView!.layer.masksToBounds = true
        cell.imageView!.clipsToBounds = true
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
                
                if let cellIndex = historyTableView.indexPathForSelectedRow?.row {
                    let selectedReceiverUID = beaconHistoryList[cellIndex]["uid"]!
                    let selectedReceiverRef = Firebase(url: "https://changr.firebaseio.com/users/\(selectedReceiverUID)")
                    
                        selectedReceiverRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                            let value = snapshot.value as! NSDictionary
                            destination.beaconData = value["beaconMinor"] as? String
                        })
                }
            }
        }
    }
}
