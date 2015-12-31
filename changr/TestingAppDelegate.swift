//
//  TestingAppDelegate.swift
//  changr
//
//  Created by Samuel Overloop on 31/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit
import CoreLocation

class TestingAppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var ref: MockFirebase!

    func isUserLoggedIn() -> Bool {
        if(ref.authData != nil) {
            return true
        } else {
            return false
        }
    }
}