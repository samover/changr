//
//  CurrentUser.swift
//  changr
//
//  Created by Samuel Overloop on 06/01/16.
//  Copyright © 2016 Samuel Overloop. All rights reserved.
//
//
//import UIKit
//import Firebase
//
//class CurrentUser {
//    var firebase = FirebaseWrapper()
//    var appDelegate: AppDelegate!
//    var userData: NSDictionary?
//    var fetched: Bool!
//    
//    init() {
//        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
//        self.fetched = false
//        self.fetchUserData()
//    }
//    
//    func fetchUserData() -> Void {
//        firebase.authRef().observeSingleEventOfType(.Value, withBlock: { snapshot in
//            print(snapshot.value)
//            self.userData = snapshot.value as? NSDictionary
//            self.fetched = true
//        })
//    }
//
//    func exists() -> Bool {
//        if(firebase.ref.authData != nil) {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func type() -> String? {
//        return userData!["UserType"] as? String
//    }
//    
//}