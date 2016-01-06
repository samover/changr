//
//  FirebaseWrapper.swift
//  changr
//
//  Created by Samuel Overloop on 01/01/16.
//  Copyright © 2016 Samuel Overloop. All rights reserved.
//

import UIKit
import Firebase

class FirebaseWrapper {
    var ref: Firebase!
    var userData: NSDictionary?
    var fetched: Bool
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        self.ref = NSProcessInfo.processInfo().arguments.contains("TESTING") ? MockFirebase() : Firebase(url:"https://changr.firebaseio.com")
        self.fetched = false
    }
    
    func isUserLoggedIn() -> Bool {
        if(ref.authData != nil) {
            let userData = defaults.dictionaryForKey("userData")
            print(userData)
            return true
        } else {
            return false
        }
    }
        
    func authRef() -> Firebase {
        return ref.childByAppendingPath("users/\(ref.authData.uid)")
    }
    
    func childRef(path: String) -> Firebase {
        return ref.childByAppendingPath(path)
    }
    
    func fetchUserData() -> Void {
        authRef().observeSingleEventOfType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.userData = snapshot.value as? NSDictionary
            self.fetched = true
        })
    }
    
    func setPersistenceEnabled() -> Void {
        if(!isTestEnvironment()) {
            Firebase.defaultConfig().persistenceEnabled = true
        }
    }
    
    private func isTestEnvironment() -> Bool {
        return NSProcessInfo.processInfo().arguments.contains("TESTING")
    }
    
}
