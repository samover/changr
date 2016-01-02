//
//  firebase.swift
//  MockFirebase
//
//  Created by Samuel Overloop on 30/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import Foundation

class MockFirebase: Firebase {
    
    var authError:NSError? = NSError(domain: "User authentication", code: 1, userInfo: nil)
    var user: User!
    var users: [User] = []
    var current_user: User?

    override var authData: FAuthData? {
        get {
            if let authUserData = current_user {
                return authUserData
            } else {
                return nil
            }
        }
    }
    
    override func authUser(email: String!, password: String!, withCompletionBlock block: ((NSError!, FAuthData!) -> Void)!) {
        var error = authError

        for user in users {
            if(user.email! == email && user.password == password) {
                print(user.email)
                current_user = user
                error = nil
            }
        }

        block(error, authData)
    }
    
    override func observeEventType(eventType: FEventType, andPreviousSiblingKeyWithBlock block: ((FDataSnapshot!, String!) -> Void)!) -> UInt {
        return 1
    }
    
    override func childByAppendingPath(pathString: String!) -> Firebase! {
        return Firebase()
    }
    
    override func createUser(email: String!, password: String!, withCompletionBlock block: ((NSError!) -> Void)!) {
        var error = authError
        var exists = false
        
        for existingUser in users {
            if (existingUser.email == email) {
                exists = true
            }
        }
        
        if(!exists) {
            user = User(email: email, password: password)
            users += [user]
            error = nil
        }
        
        block(error)
    }
    
    override func unauth() {
        current_user = nil
    }
}

class User: FAuthData {
    var email: String!
    var password: String!
    
    init?(email: String, password: String) {
        super.init()
        
        if(email == "" || password == "") { return nil }
        self.email = email
        self.password = password
    }
    
    override var uid: String {
        get {
            return "a8cfdc95-e221-4108-967a-7ac7e3d48b6d"
        }
    }
    
    override var provider: String {
        get {
            return "password"
        }
    }
    
    override var expires: NSNumber {
        get {
            return 1451558993
        }
    }
    
    override var auth: [NSObject: AnyObject] {
        get {
            return [ "uid": uid, "provider": provider]
        }
    }
    
    override var token: String {
        get {
            return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2IjowLCJkIjp7InByb3ZpZGVyIjoicGFzc3dvcmQiLCJ1aWQiOiJhOGNmZGM5NS1lMjIxLTQxMDgtOTY3YS03YWM3ZTNkNDhiNmQifSwiaWF0IjoxNDUxNDcyNTkzfQ.JcT_Pu7pbfjNTNrgvdct1rCG9z_sftYoRTRtUtM423Q"
        }
    }
    
    override var providerData: [NSObject: AnyObject] {
        get {
            return [
                "profileImageURL": "https://secure.gravatar.com/avatar/8da15a9afec4c29790fff3a0a2b45608?d=retro",
                "isTemporaryPassword": 0,
                "email": email
            ]
        }
    }
}