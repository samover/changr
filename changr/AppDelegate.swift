//
//  AppDelegate.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import CoreLocation
import DrawerController
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    let firebase = FirebaseWrapper()
    let notification = Notification()
    var centerContainer: DrawerController?

    var window: UIWindow?
    var rootController: UIViewController?

    var beacons = [CLBeacon]()
    let locationManager = CLLocationManager()
    
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")

    override init() {
        // Throws an exception for some reason
//        FirebaseWrapper().setPersistenceEnabled()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentProduction: "AaAqHxwwgSS6LjhixZVQqFZNeCrjzaDgwIdSBvOoxptrcGAmDTvtrNrH4500aR7o9b42WUe-hTVq62hA", PayPalEnvironmentSandbox: "AUOe5U1jc9EbPxihVXMPlFVbsqcZwAan42In7Rue5QZZsAL3H3U9uSlQdBSKUyznjRUEBdAxTDGY_7KH"])
        
        notification.build()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: NSSet(array: [notification.category()]) as? Set<UIUserNotificationCategory>))

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        rootController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController

        let leftSideNav = UINavigationController(rootViewController: leftViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)

        centerContainer = DrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav)
        centerContainer!.openDrawerGestureModeMask = OpenDrawerGestureMode.PanningCenterView;
        centerContainer!.closeDrawerGestureModeMask = CloseDrawerGestureMode.PanningCenterView;

        window!.rootViewController = firebase.isUserLoggedIn() ? centerContainer : rootController
        window!.makeKeyAndVisible()

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
        if firebase.isUserLoggedIn() {
            self.beacons = beacons

            NSNotificationCenter.defaultCenter().postNotificationName("updateBeaconTableView", object: self.beacons)

            firebase.authRef().observeEventType(.Value, withBlock: { snapshot in
                let value = snapshot.value as! NSDictionary
                for beaconID in self.beacons {
                    let beaconMinor = beaconID.minor.stringValue
                    if(self.notification.containsHistory(beaconMinor) && value["userType"] as! String == "Donor") {
                        self.notification.send(beaconMinor)
                    }
                }
            })
        }
    }

    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        notification.resetHistory()
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
