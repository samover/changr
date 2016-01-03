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
}
