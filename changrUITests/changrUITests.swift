//
//  changrUITests.swift
//  changrUITests
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import XCTest

class changrUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSignupAsNewUser() {
        
        let app = XCUIApplication()
        
        let logoutButton = app.buttons["Logout"]
        
        if(logoutButton.exists) {
            logoutButton.tap()
        }
        
        app.buttons["Not yet registered? Sign up now."].tap()
        
        let exampleGmailComTextField = app.textFields["Example@gmail.com"]
        exampleGmailComTextField.tap()
        exampleGmailComTextField.typeText("user@test.com")
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("username")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        let passwordConfirmationSecureTextField = app.secureTextFields["Password Confirmation"]
        passwordConfirmationSecureTextField.tap()
        passwordConfirmationSecureTextField.typeText("password")
        app.buttons["Sign Up"].tap()
        
        XCTAssert(app.buttons["Logout"].exists)
    }
    
    func testLoginAsRegisterdUser {
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        
        // Failed test
        let app = XCUIApplication()
        let exampleGmailComTextField = app.textFields["Example@gmail.com"]
        exampleGmailComTextField.typeText("sam")
        
        let moreNumbersKey = app.keys["more, numbers"]
        moreNumbersKey.pressForDuration(0.6);
        moreNumbersKey.pressForDuration(0.6);
        exampleGmailComTextField.typeText("@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("")
        passwordSecureTextField.typeText("password")
        app.buttons["Sign In"].tap()
        XCTAssert(
        
    }
}
