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

    let ref = Firebase(url: "https://changr.firebaseio.com/")
    var centerContainer: MMDrawerController?
    var rootController: UIViewController?
    var enteredRegion = false
    var beacons = [CLBeacon]()
    let locationManager = CLLocationManager()

    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        // Building the Push Notification:

        let notificationActionDismiss :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionDismiss.identifier = "DISMISS_IDENTIFIER"
        notificationActionDismiss.title = "Dismiss"
        notificationActionDismiss.activationMode = UIUserNotificationActivationMode.Background
        notificationActionDismiss.destructive = true
        notificationActionDismiss.authenticationRequired = false

        let notificationActionViewProfile :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionViewProfile.identifier = "VIEW_PROFILE_IDENTIFIER"
        notificationActionViewProfile.title = "View Profile"
        notificationActionViewProfile.activationMode = UIUserNotificationActivationMode.Foreground
//        notificationActionViewProfile.destructive = false
        notificationActionViewProfile.authenticationRequired = false

        let notificationCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = "RECEIVER_IN_RANGE_ALERT"
        notificationCategory.setActions([notificationActionDismiss, notificationActionViewProfile], forContext: UIUserNotificationActionContext.Default)

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: NSSet(array: [notificationCategory]) as! Set<UIUserNotificationCategory>))

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

        if (isUserLoggedIn())
        {
            window!.rootViewController = centerContainer
            window!.makeKeyAndVisible()
        }
        else
        {
            window!.rootViewController = rootController
            window!.makeKeyAndVisible()
        }

        return true
    }
    
    // Directing a user to a specific view controller when they tap on "View Profile" after receiving a push notification:
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if identifier == "VIEW_PROFILE_IDENTIFIER" {
            print("View profile action")
        
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FormController") as! FormController
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

        default:
            print("default case")
        }
    }
    
    // Setting the Push Notification:

    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        switch state {
            case .Inside:
                if enteredRegion {
                    let localNotification:UILocalNotification = UILocalNotification()
                    localNotification.alertAction = "view options"
                    localNotification.alertBody = "You are in range of beacons"
                    localNotification.category = "RECEIVER_IN_RANGE_ALERT"
                    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                }
            default: break
        }
    }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        enteredRegion = true
    }

    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        enteredRegion = false
    }

    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [CLBeacon]!, inRegion region: CLBeaconRegion!) {
        self.beacons = beacons
        NSNotificationCenter.defaultCenter().postNotificationName("updateBeaconTableView", object: self.beacons)
    }

}
