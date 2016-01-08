//
//  menuItems.swift
//  changr
//
//  Created by Samuel Overloop on 26/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import XCTest

class menuItems: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UIApplication.sharedApplication().delegate = TestingAppDelegate()
    }
    
    func testInitialization() {
        let item = MenuItems(title: "Foo", icon: nil)
        XCTAssertNotNil(item)
    }
    func testFailedInitialization() {
        let item = MenuItems(title: "", icon: nil)
        XCTAssertNil(item)
    }
}
