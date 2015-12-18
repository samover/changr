//
//  BeaconTableViewController.swift
//  changr
//
//  Created by Hamza Sheikh on 17/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BeaconTableViewController : UITableViewController {

    @IBOutlet var beaconTableView: UITableView!
    
    let showBeaconSelectedIdentifier = "ShowBeaconSelected"

    var beacons = [CLBeacon]()

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView:", name: "updateBeaconTableView", object: nil)
    }

    override func didReceiveMemoryWarning() {

    }

    func updateView(note: NSNotification!){
        beacons = note.object! as! [CLBeacon]
        beaconTableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        print(beacons.count)
        print(beacons)
        return beacons.count

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell", forIndexPath: indexPath) as UITableViewCell

        let major = beacons[indexPath.row].major as NSNumber?
        var majorString = major!.stringValue

        let minor = beacons[indexPath.row].minor as NSNumber?
        var minorString = minor!.stringValue

        let proximity = beacons[indexPath.row].proximity

        var proximityString = String()

        switch proximity
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

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Beacons in range"
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showBeaconSelectedIdentifier {
            if let destination = segue.destinationViewController as? FormViewController {
                if let beaconIndex = tableView.indexPathForSelectedRow?.row {
//                    let beaconMajor = beacons[beaconIndex].major as NSNumber?
                    let beaconMinor = beacons[beaconIndex].minor as NSNumber?
                    // We only want to get the Minor Value for now
                    destination.beaconName = "\(beaconMinor!)"
                }
            }
        }
    }

    
    
    
    
    
    
}