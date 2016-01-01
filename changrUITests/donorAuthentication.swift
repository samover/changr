//
//  donorAuthentication.swift
//  donorAuthentication
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import XCTest

class donorAuthentication: XCTestCase {
    
    let email:String = "donor@makers.com"
    let password:String = "password"
    let app = XCUIApplication()
    var exists: NSPredicate!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments += ["TESTING"]
        exists = NSPredicate(format: "exists == true")
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccessfulSignupAsNewDonor() {
        let signOutButton = app.navigationBars["Home"].buttons["Sign out"]
        
        XCTAssertFalse(signOutButton.exists)
        
        expectationForPredicate(exists, evaluatedWithObject: signOutButton, handler: nil)
        
        signUpAsDonor(email, password: password)
        
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(signOutButton.exists)
    }
    
    func testFailedSignupAsNewDonorWhenUserAlreadyExists() {
        let signOutButton = app.navigationBars["Home"].buttons["Sign out"]
        
        XCTAssertFalse(signOutButton.exists)
        signUpAsDonor(email, password: password)
        signOutButton.tap()
        signUpAsDonor(email, password: password)
        
        XCTAssertFalse(signOutButton.exists)
        XCTAssert(app.staticTexts["Please enter a valid password and email"].exists)
    }
    
    func testLoginAsExistingDonor() {
        let signOutButton = app.navigationBars["Home"].buttons["Sign out"]
        
        XCTAssertFalse(signOutButton.exists)
        signUpAsDonor(email, password: password)
        signOutButton.tap()
        login(email, password: password)
        
        XCTAssert(signOutButton.exists)
    }
    
    // HELPER METHODS

    func signUpAsDonor(email: String, password: String) {
        let exampleGmailComTextField = app.textFields["Example@gmail.com"]
        exampleGmailComTextField.tap()
        exampleGmailComTextField.typeText(email)
        app.buttons["Next"].tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.typeText(password)
        app.buttons["Done"].tap()
        app.pickerWheels["Donor"].tap()
        app.buttons["SIGN UP"].tap()
    }

    func login(email: String, password: String) {
        let exampleGmailComTextField = app.textFields["Example@gmail.com"]
        exampleGmailComTextField.tap()
        exampleGmailComTextField.typeText(email)
        app.buttons["Next"].tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.typeText(password)
        app.buttons["Done"].tap()
        app.buttons["LOGIN"].tap()
    }
}

