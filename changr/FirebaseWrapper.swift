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
    
    init() {
        self.ref = NSProcessInfo.processInfo().arguments.contains("TESTING") ? MockFirebase() : Firebase(url:"https://changr.firebaseio.com")
    }
    
    func isUserLoggedIn() -> Bool {
        if(ref.authData != nil) {
            return true
        } else {
            return false
        }
    }
    
    func fetchData() -> NSDictionary {
        if(isUserLoggedIn() && userData != nil) {
            return userData!
        }
        else if ( isUserLoggedIn() ) {
            authRef().obs
            authRef().observeSingleEventOfType(.Value, withBlock: { snapshot in
                self.userData = snapshot.value as? NSDictionary
            })
        }
        else {
            userData = nil
            return userData!
        }
    }
    
    func authRef() -> Firebase {
        return ref.childByAppendingPath("users/\(ref.authData.uid)")
    }
    
    func childRef(path: String) -> Firebase {
        return ref.childByAppendingPath(path)
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
