//
//  OnTheMapTests.swift
//  OnTheMapTests
//
//  Created by Moath_Othman on 6/6/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import UIKit
import XCTest
import FBSDKLoginKit
class OnTheMapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        var login = FBSDKLoginButton()
         
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
