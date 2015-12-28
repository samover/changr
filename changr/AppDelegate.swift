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

    let ref = Firebase(url: "https://changr.firebaseio.com/users")
    var centerContainer: MMDrawerController?
    var rootController: UIViewController?
    var beacons = [CLBeacon]()
    var receiverName: String!
    let locationManager = CLLocationManager()
    var stopSending = false

    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        // Building the Push Notification Options:

        let notificationActionViewProfile :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionViewProfile.identifier = "VIEW_PROFILE_IDENTIFIER"
        notificationActionViewProfile.title = "View Profile"
        notificationActionViewProfile.activationMode = UIUserNotificationActivationMode.Foreground
        notificationActionViewProfile.authenticationRequired = false

        let notificationCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = "RECEIVER_IN_RANGE_ALERT"
        notificationCategory.setActions([notificationActionViewProfile], forContext: UIUserNotificationActionContext.Default)

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: NSSet(array: [notificationCategory]) as? Set<UIUserNotificationCategory>))

        func isUserLoggedIn() -> Bool {
            if(ref.authData != nil) {
                return true
            } else {
                return false
            }
        }

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        rootController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController

        let leftSideNav = UINavigationController(rootViewController: leftViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)

        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav)
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView;

        if (isUserLoggedIn()) {
            window!.rootViewController = centerContainer
            window!.makeKeyAndVisible()
        }
        else {
            window!.rootViewController = rootController
            window!.makeKeyAndVisible()
        }

        return true
    }
    
    // Checking User permissions for using background location updates

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {

            case .AuthorizedAlways:
                locationManager.startMonitoringForRegion(region)
                locationManager.startRangingBeaconsInRegion(region)
                locationManager.requestStateForRegion(region)

            case .Denied:
                let alert = UIAlertController(title: "Warning", message: "You've disabled location update which is required for this app to work. Go to your phone settings and change the permissions.", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
                alert.addAction(alertAction)

                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)

            default:
                print("default case")
        }
    }
    
    // Start searching for nearby beacons and store the found beacons in an array:
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        self.beacons = beacons
        NSNotificationCenter.defaultCenter().postNotificationName("updateBeaconTableView", object: self.beacons)
        
        sendNotification() // When a beacon is found, send out a local notification to user
        
    }
    
    // Sending the Local Push Notification:
    
    func sendNotification() {
        
        var beaconInfo = [String:String]()
        
        if self.beacons.first != nil {
            if stopSending == false {
                
                // This gets the name of the receiver that a user walked past:
                
                ref.observeEventType(.Value, withBlock: { snapshot in
                    for item in snapshot.children {
                        let child = item as! FDataSnapshot
                            if child.value["beaconMinor"] as? String == self.beacons.first!.minor.stringValue {
                                self.receiverName = child.value["fullName"] as! String
                            }
                    }
                })
                
                beaconInfo["beaconMinor"] = "\(self.beacons.first!.minor)" // This gets the minor value of the beacon that the user walked past
                let localNotification:UILocalNotification = UILocalNotification()
                localNotification.alertAction = "view options"
                localNotification.alertBody = "Please take a moment to view \(self.receiverName)'s profile and see why they need your help."
                localNotification.category = "RECEIVER_IN_RANGE_ALERT"
                localNotification.userInfo = beaconInfo // This stores the beacon minor value within the notification
                localNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
                stopSending = true // This is to prevent repeat notifications
            }
        }
    }
    
    // Once the user has exited a region then turn notification sending back on for the next beacon they walk past:

    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        stopSending = false
    }
    
    // Directing a user to a specific view controller when they tap on "View Profile" after receiving a local push notification:
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        if identifier == "VIEW_PROFILE_IDENTIFIER" {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewReceiverProfileController") as! ViewReceiverProfileController
            destinationViewController.beaconData = notification.userInfo!["beaconMinor"] as! String
            window!.rootViewController = destinationViewController
            window!.makeKeyAndVisible()
        }
        completionHandler()
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

}
