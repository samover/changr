//
//  BeaconTableViewController.swift
//  changr
//
//  Created by Hamza Sheikh on 17/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

class BeaconTableViewController : UITableViewController {
    
    @IBOutlet var beaconTableView: UITableView!
    
    var beacons : AnyObject = []
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView:", name: "updateBeaconTableView", object: nil)
        //listen for notifications with selector updateView
    }
    
    func updateView(note: NSNotification!){
        beacons = note.object!
        beaconTableView.reloadData() //update table data
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(beacons)
        return beacons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell", forIndexPath: indexPath) as UITableViewCell
        
        let major = beacons[indexPath.row].major as NSNumber?
        let majorString = major?.stringValue
        
        let minor = beacons[indexPath.row].minor as NSNumber?
        let minorString = minor?.stringValue
        
        let proximity = beacons[indexPath.row].proximity
        var proximityString = String()
        
        switch proximity!
        {
        case .Near:
            proximityString = "Near"
        case .Immediate:
            proximityString = "Immediate"
        case .Far:
            proximityString = "Far"
        case .Unknown:
            proximityString = "Unknown"
        }
        
        cell.textLabel?.text = "Major: \(majorString) Minor: \(minorString) Proximity: \(proximityString) "
        //display beacon values in cell text label
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Beacons in range"
    }
    
    
}