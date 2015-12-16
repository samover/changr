//
//  User.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class User {
    
    // MARK: Properties
    
//    var firstName: String
//    var lastName: String
    var email: String
    var uid: String
    
    // Initialize from Firebase
    init(authData: FAuthData) {
        self.uid = authData.uid
        self.email = authData.providerData["email"] as! String
//        self.firstName = firstName
//        self.lastName = lastName
//        
//        if firstName.isEmpty || lastName.isEmpty {
//            return nil
//        }
    }
    
    // Initialize from arbitrary data
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
