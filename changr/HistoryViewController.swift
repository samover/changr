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
    var items = [NSDictionary]()
    
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
        items = [NSDictionary]()
        
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
                returnValue = items.count
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
    
    // MARK:- Configure Cell
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let dict = items[indexPath.row]
        
        cell.textLabel?.text = dict["fullName"] as? String
        cell.detailTextLabel?.text = dict["time"] as? String
        
        let base64String = dict["profileImage"] as! String
        populateImage(cell, imageString: base64String)
    }
    
    // MARK:- Populate Image
    
    func populateImage(cell:UITableViewCell, imageString: String) {

        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        let decodedImage = UIImage(data: decodedData!)
        
        cell.imageView!.image = decodedImage
        
    }
    
    func loadDataFromFirebase() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        firebase.ref.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.items = tempItems
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
