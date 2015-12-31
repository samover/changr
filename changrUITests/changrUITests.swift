//
//  changrUITests.swift
//  changrUITests
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import XCTest

class changrUITests: XCTestCase {
    
    let email:String = "donor@gmail.com"
    let password:String = "password"
    let app = XCUIApplication()
    var ref: MockFirebase!
    var loginController:LoginController = LoginController()
    var testingAppDelegate: TestingAppDelegate!


    override func setUp() {
        super.setUp()
        continueAfterFailure = false
//        app.launchArguments.append("TESTING")
        UIApplication.sharedApplication().delegate = TestingAppDelegate()
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
//        loginController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
//        loginController.loadView()
//        loginController.viewDidLoad()
//        testingAppDelegate = UIApplication.sharedApplication().delegate as! TestingAppDelegate
//        loginController.ref = testingAppDelegate.ref
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSignupAsNewDonor() {
        
        let exampleGmailComTextField = app.textFields["Example@gmail.com"]
        exampleGmailComTextField.tap()
        exampleGmailComTextField.typeText(email)
        app.buttons["Next"].tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.typeText(password)
        app.buttons["Done"].tap()
        app.pickerWheels["Donor"].tap()
        app.buttons["SIGN UP"].tap()
        
        XCTAssert(app.buttons["Sign out"].exists)
    }
    
    func testSignupAsNewReceiver() {
        
        let app = XCUIApplication()
        
        let exampleGmailComTextField = app.textFields["Example@gmail.com"]
        exampleGmailComTextField.tap()
        exampleGmailComTextField.typeText("receiver@makers.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        app.pickerWheels["Receiver"].tap()
        app.buttons["Sign Up"].tap()
        
        XCTAssert(app.buttons["Save Profile"].exists)
    }
    
    func testLogin() {
        
        let app = XCUIApplication()
        
        let exampleGmailComTextField = app.textFields["Example@gmail.com"]
        exampleGmailComTextField.tap()
        exampleGmailComTextField.typeText("receiver@makers.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        app.pickerWheels["Receiver"].tap()
        app.buttons["Login"].tap()
        
        XCTAssert(app.buttons["Logout"].exists)
    }
    
//    func testLoginAsRegisterdUser {
//        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
//        
//        // Failed test
//        let app = XCUIApplication()
//        let exampleGmailComTextField = app.textFields["Example@gmail.com"]
//        exampleGmailComTextField.typeText("sam")
//        
//        let moreNumbersKey = app.keys["more, numbers"]
//        moreNumbersKey.pressForDuration(0.6);
//        moreNumbersKey.pressForDuration(0.6);
//        exampleGmailComTextField.typeText("@gmail.com")
//        
//        let passwordSecureTextField = app.secureTextFields["Password"]
//        passwordSecureTextField.tap()
//        passwordSecureTextField.typeText("")
//        passwordSecureTextField.typeText("password")
//        app.buttons["Sign In"].tap()
//        
//    }
}
