//
//  AppDelegate.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?

    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")
    //define region for monitoring
    
    var enteredRegion = false
    var beacons = []
    
    func application(application: UIApplication, _didFinishLaunchingWithOptions launchOptions: [NSObject: CLBeacon]?) -> Bool {
        
        locationManager.requestAlwaysAuthorization() //request permission for location updates
        locationManager.delegate = self
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        //set notification settings
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
       
       
    }

    func applicationDidEnterBackground(application: UIApplication) {
       
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
       
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status{
            
        case .AuthorizedAlways:
            
            locationManager.startMonitoringForRegion(region)
            locationManager.startRangingBeaconsInRegion(region)
            locationManager.requestStateForRegion(region)
            
        case .Denied:
            
            let alert = UIAlertController(title: "Warning", message: "You've disabled location update which is required for this app to work. Go to your phone settings and change the permissions.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(alertAction)
            
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
            //display error message if location updates are declined
            
        default:
            print("default case")
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        switch state {
            
        case .Unknown:
            print("unknown")
            
        case .Inside:
            
            var text : String = "Tap here to enter app"
            
            if enteredRegion {
                text = "You have entered the region."
            }
            Notifications.display(text)
            
        case .Outside:
            
            var text : String = "Why aren't you here? :("
            
            if !enteredRegion {
                text = "You are outside of the region"
            }
            Notifications.display(text)
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, _didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        self.beacons = beacons
        print(beacons)
        
        NSNotificationCenter.defaultCenter().postNotificationName("updateBeaconTableView", object: self.beacons)
        //send updated beacons array to BeaconTableViewController
    }
    
    func locationManager(manager: CLLocationManager,didEnterRegion region: CLRegion){
        enteredRegion = true
    }
    
    func locationManager(manager: CLLocationManager!,idExitRegion region: CLRegion!){
        enteredRegion = false
    }

}
    



