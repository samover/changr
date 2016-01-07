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
    var firebase: FirebaseWrapper!
    var appDelegate: AppDelegate!
    var beaconHistoryList = [NSDictionary]()
    var donationsList = [["amount" : "Donation Amount: £2.00", "date" : "Paid On: 01/01/2016"], ["amount" : "Donation Amount: £4.50", "date" : "Paid On: 03/01/2016"], ["amount" : "Donation Amount: £6.50", "date" : "Paid On: 16/12/2015"], ["amount" : "Donation Amount: £10.00", "date" : "Paid On: 29/12/2015"], ["amount" : "Donation Amount: £3.50", "date" : "Paid On: 03/01/2016"], ["amount" : "Donation Amount: £7.00", "date" : "Paid On: 11/12/2015"], ["amount" : "Donation Amount: £2.20", "date" : "Paid On: 29/12/2015"], ["amount" : "Donation Amount: £9.50", "date" : "Paid On: 10/12/2015"], ["amount" : "Donation Amount: £5.00", "date" : "Paid On: 20/12/2016"], ["amount" : "Donation Amount: £1.50", "date" : "Paid On: 31/12/2015"]]
    
    // MARK: Outlets
    @IBOutlet weak var historySegmentedControl: UISegmentedControl!
    @IBOutlet weak var historyTableView: UITableView!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        firebase = appDelegate.firebase
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
        
        let path = "users/\(firebase.ref.authData.uid)/beaconHistory"
        
        firebase.childRef(path).observeSingleEventOfType(.Value, withBlock: { snapshot in
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
                historyCell!.textLabel!.text = donationsList[indexPath.row]["amount"]
                historyCell!.detailTextLabel?.text = donationsList[indexPath.row]["date"]
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
        let path = "users/\(dict["uid"]!)"

        firebase.childRef(path).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let value = snapshot.value as! NSDictionary
            let base64String = value["profileImage"] as? String

            cell.textLabel?.text = value["fullName"] as? String
            cell.detailTextLabel?.text = self.timeAgoInWords(dict["time"] as! String)
            
            self.populateImage(cell, imageString: base64String!)
        })
    }
    
    // MARK: Populate Image
    
    func populateImage(cell:UITableViewCell, imageString: String) {
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        let newImage = resizeImage(decodedImage!, toTheSize: CGSizeMake(65, 65))
        let cellImageLayer: CALayer?  = cell.imageView!.layer
        cellImageLayer!.cornerRadius = 32.5
        cellImageLayer!.masksToBounds = true
        cell.imageView!.image = newImage
    }
    
    // Resize the Image
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        let scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRectMake( 0, 0, width, height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.drawInRect(rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
    }
    
    // MARK: Format DATE 
    func timeAgoInWords(dateString: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss x"
        let date = dateFormatter.dateFromString(dateString)

        return timeAgoSince(date!)
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
