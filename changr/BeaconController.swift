//
//  BeaconController.swift
//  changr
//
//  Created by Fergus Lemon on 17/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//
//
//import UIKit
//import CoreLocation
//
//class BeaconController: UIViewController, CLLocationManagerDelegate {
//
//    // MARK: Properties
//
//
//    let locationManager = CLLocationManager()
//    let UUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
//    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: UUID)!, identifier: "Estimotes")
//    var beaconsArray = [ ["Name": "Beacon1", "UUID": UUID, "Major": 8981, "Minor": 49281] ]
//
//    // MARK: UIViewController Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        locationManager.delegate = self
//        locationManager.startRangingBeaconsInRegion(region)
//
//
//    }
//
//    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
//        print(beacons)
//    }
//
//
//}
