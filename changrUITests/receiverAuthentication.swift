//
//  receiverAuthentication.swift
//  changr
//
//  Created by Samuel Overloop on 01/01/16.
//  Copyright © 2016 Samuel Overloop. All rights reserved.
//

import XCTest

class receiverAuthentication: XCTestCase {
    
    
    let app = XCUIApplication()
    let email:String = "receiver@makers.com"
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
    
    func testSuccessfulSignupAsNewReceiver() {
        
        XCTAssertFalse(signOutButton.exists)
        signUp(email, password: password, role: "Receiver")
        XCTAssert(app.navigationBars["Complete Your Profile"].exists)
    }
    
    func testFailedSignupAsNewReceiverWhenUserAlreadyExists() {
        XCTAssertFalse(signOutButton.exists)
        
        signUp(email, password: password, role: "Donor")
        signOutButton.tap()
        signUp(email, password: password, role: "Receiver")
        
        XCTAssertFalse(app.navigationBars["Complete Your Profile"].exists)
        XCTAssert(app.staticTexts["Please enter a valid password and email"].exists)
    }

    // ONLY POSSIBLE AFTER COMPLETING PROFILE
//    func testLoginAsExistingReceiver() {
//        XCTAssertFalse(signOutButton.exists)
//        
//        signUp(email, password: password, role: "Receiver")
//        signOutButton.tap()
//        login(email, password: password)
//        
//        XCTAssert(signOutButton.exists)
//    }
//    
//    func testLoginFailedWrongPassword() {
//        XCTAssertFalse(signOutButton.exists)
//        
//        signUp(email, password: password, role: "Receiver")
//        signOutButton.tap()
//        login(email, password: "test")
//        
//        XCTAssertFalse(signOutButton.exists)
//        XCTAssert(app.staticTexts["Username or password incorrect"].exists)
//    }
//    
//    func testLoginFailedWrongUsername() {
//        XCTAssertFalse(signOutButton.exists)
//        
//        signUp(email, password: password, role: "Receiver")
//        signOutButton.tap()
//        login("receiver@makers.com", password: "password")
//        
//        XCTAssertFalse(signOutButton.exists)
//        XCTAssert(app.staticTexts["Username or password incorrect"].exists)
//    }
    
    // HELPER METHODS
    
    func signUp(email: String, password: String, role: String) {
        emailTextField.tap()
        emailTextField.typeText(email)
        app.buttons["Next"].tap()
        
        passwordTextField.typeText(password)
        app.buttons["Done"].tap()
        app.pickerWheels.element.adjustToPickerWheelValue(role)
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

