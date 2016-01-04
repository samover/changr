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
    
//    class MockFormController: FormController {
//        override func viewDidLoad() {
//            completeProfileButton.enabled = true
//        }
//    }
//    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
//        UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FormController") as! MockFormController
        
        emailTextField = app.textFields["Example@gmail.com"]
        passwordTextField = app.secureTextFields["Password"]
        signOutButton = app.navigationBars["Home"].buttons["Sign out"]
        
        app.launchArguments += ["TESTING"]
        app.launch()
    }
    
    func testCompleteProfile() {
        
        signUp(email, password: password, role: "Receiver")
//        let alertButton = app.alerts["\u{201c}changr\u{201d} Would Like to Access Your Photos"]
//        let exists = NSPredicate(format: "exists == true")
//        expectationForPredicate(exists, evaluatedWithObject: alertButton, handler: nil)
        let completeProfileButton = app.buttons["COMPLETE PROFILE"]
        
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
        app.buttons["Done"].tap()
        
        XCTAssert(completeProfileButton.enabled)
        
        completeProfileButton.tap()
        
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




