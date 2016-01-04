//
//  completeReceiverProfile.swift
//  changr
//
//  Created by Hamza Sheikh on 04/01/2016.
//  Copyright © 2016 Samuel Overloop. All rights reserved.
//

import XCTest

class completeReceiverProfile: XCTestCase {
    
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
    
    func testCompleteProfile() {
        signUp(email, password: password, role: "Receiver")
        let alertButton = app.alerts["\u{201c}changr\u{201d} Would Like to Access Your Photos"]
        let exists = NSPredicate(format: "exists == true")
        expectationForPredicate(exists, evaluatedWithObject: alertButton, handler: nil)
        
        let fullNameTextField = app.textFields["FULL NAME"]
        fullNameTextField.tap()
        fullNameTextField.typeText("Hamza Sheikh")
        
        app.buttons["MALE"].tap()
        
        let dateTextField = app.textFields["DD"]
        dateTextField.tap()
        dateTextField.typeText("16")
        
        let monthTextField = app.textFields["MM"]
        monthTextField.tap()
        monthTextField.typeText("07")
        
        let yearTextField = app.textFields["YYYY"]
        yearTextField.tap()
        yearTextField.typeText("2015")
        
//        app.images["defaultImage"].tap()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        waitForExpectationsWithTimeout(10, handler: nil)
        alertButton.collectionViews.buttons["OK"].tap()
        app.tables.buttons["Camera Roll"].tap()
        app.collectionViews.cells["Photo, Landscape, March 13, 2011, 12:17 AM"].tap()
        app.buttons["COMPLETE PROFILE"].tap()
        
        XCTAssert(app.staticTexts["Your Balance is: £0"].exists)
    }
    
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




