//
//  donorAuthentication.swift
//  donorAuthentication
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import XCTest

class donorAuthentication: XCTestCase {
    
    let app = XCUIApplication()
    let email:String = "donor@makers.com"
    let password:String = "password"
    var signOutButton: XCUIElement!
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        emailTextField = app.textFields["Example@gmail.com"]
        passwordTextField = app.secureTextFields["Password"]
        signOutButton = app.navigationBars["Home"].buttons["Sign out"]
        
        app.launchArguments += ["TESTING"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccessfulSignupAsNewDonor() {
        XCTAssertFalse(signOutButton.exists)
        signUpAsDonor(email, password: password)
        XCTAssert(signOutButton.exists)
    }
    
    func testFailedSignupAsNewDonorWhenUserAlreadyExists() {
        XCTAssertFalse(signOutButton.exists)
        
        signUpAsDonor(email, password: password)
        signOutButton.tap()
        signUpAsDonor(email, password: password)
        
        XCTAssertFalse(signOutButton.exists)
        XCTAssert(app.staticTexts["Please enter a valid password and email"].exists)
    }
    
    func testLoginAsExistingDonor() {
        XCTAssertFalse(signOutButton.exists)
        
        signUpAsDonor(email, password: password)
        signOutButton.tap()
        login(email, password: password)
        
        XCTAssert(signOutButton.exists)
    }
    
    func testLoginFailedWrongPassword() {
        XCTAssertFalse(signOutButton.exists)
        
        signUpAsDonor(email, password: password)
        signOutButton.tap()
        login(email, password: "test")
        
        XCTAssertFalse(signOutButton.exists)
        XCTAssert(app.staticTexts["Username or password incorrect"].exists)
    }
    
    func testLoginFailedWrongUsername() {
        XCTAssertFalse(signOutButton.exists)
        
        signUpAsDonor(email, password: password)
        signOutButton.tap()
        login("receiver@makers.com", password: "password")
        
        XCTAssertFalse(signOutButton.exists)
        XCTAssert(app.staticTexts["Username or password incorrect"].exists)
    }
    
    // HELPER METHODS

    func signUpAsDonor(email: String, password: String) {
        emailTextField.tap()
        emailTextField.typeText(email)
        app.buttons["Next"].tap()
        
        passwordTextField.typeText(password)
        app.buttons["Done"].tap()
        app.pickerWheels["Donor"].tap()
        app.buttons["SIGN UP"].tap()
    }

    func login(email: String, password: String) {
        emailTextField.tap()
        emailTextField.typeText(email)
        app.buttons["Next"].tap()
        
        passwordTextField.typeText(password)
        app.buttons["Done"].tap()
        app.buttons["LOGIN"].tap()
    }
}

