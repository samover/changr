//
//  authenticationButtons.swift
//  changr
//
//  Created by Samuel Overloop on 01/01/16.
//  Copyright © 2016 Samuel Overloop. All rights reserved.
//

import XCTest

class authenticationButtons: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app.launchArguments += ["TESTING"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAllElementsExist() {
        XCTAssert(app.textFields["Example@gmail.com"].exists)
        XCTAssert(app.secureTextFields["Password"].exists)
        XCTAssert(app.pickerWheels["Donor"].exists)
        XCTAssert(app.buttons["SIGN UP"].exists)
        XCTAssert(app.buttons["LOGIN"].exists)
    }
    
    func testNextGreyedOutWhenEmailFieldEmpty() {
        app.textFields["Example@gmail.com"].tap()
        XCTAssertFalse(app.buttons["Next"].enabled)
    }
    
    func testDoneGreyedOutWhenPasswordFieldEmpty() {
        app.secureTextFields["Password"].tap()
        XCTAssertFalse(app.buttons["Done"].enabled)
    }
}
