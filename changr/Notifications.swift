//
//  Notifications.swift
//  changr
//
//  Created by Hamza Sheikh on 17/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import Firebase

class Notification {
    let firebase = FirebaseWrapper()
    var history: [String]?
    let notificationActionViewProfile :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
    let notificationCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
    
    init() {
        self.history = []
    }
    
    func build() -> Void {
        notificationActionViewProfile.identifier = "VIEW_PROFILE_IDENTIFIER"
        notificationActionViewProfile.title = "View Profile"
        notificationActionViewProfile.activationMode = UIUserNotificationActivationMode.Foreground
        notificationActionViewProfile.authenticationRequired = false
        notificationCategory.identifier = "RECEIVER_IN_RANGE_ALERT"
        notificationCategory.setActions([notificationActionViewProfile], forContext: UIUserNotificationActionContext.Default)
    }
    
    func category() -> UIMutableUserNotificationCategory {
        return notificationCategory
    }
    
    func send(beaconMinor: String) {
        updateHistory(beaconMinor)

        firebase.ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let user = item as! FDataSnapshot
                for brother in user.children {
                    let child = brother as! FDataSnapshot
                    let value = child.value as! NSDictionary
                    if(beaconMinor == value["beaconMinor"] as! String) {
                        self.push(beaconMinor, fullName: value["fullName"] as! String)
                        self.updateReceiverHistory(child.key)
                        
                    }
                }
            }
        })
    }
    
    func resetHistory() -> Void {
        self.history = []
    }
    
    func updateHistory(beaconMinor: String) -> Void {
        self.history!.append(beaconMinor)
    }
    
    func containsHistory(beaconMinor: String) -> Bool {
        return !self.history!.contains(beaconMinor)
    }
    
    private func push(beaconID: String, fullName: String) -> Void {
        var beaconInfo = [String:String]()
        
        beaconInfo["beaconMinor"] = beaconID
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "view options"
        localNotification.alertBody = "Please take a moment to view \(fullName)'s profile and see why they need your help."
        localNotification.category = "RECEIVER_IN_RANGE_ALERT"
        localNotification.userInfo = beaconInfo // This stores the beacon minor value within the notification
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    private func updateReceiverHistory(uid: String!) {
        let historyRef = firebase.ref.childByAppendingPath("users/\(firebase.ref.authData.uid)/beaconHistory")
        let historyItem = ["uid": uid as String!, "time": NSDate().description]
        historyRef.childByAutoId().updateChildValues(historyItem)
    }
    
}
