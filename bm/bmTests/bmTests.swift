//
//  bmTests.swift
//  bmTests
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import XCTest
@testable import bm

class bmTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Utility
    func testGetRandomInteger() {
        XCTAssert(getRandomInteger(maximum: 5, notAllowedInt: 3) != 3, "🍊🍊, getRandomInteger not ok")
        XCTAssert(getRandomInteger(maximum: 10, notAllowedInt: 2) != 2, "🍊🍊, getRandomInteger not ok")
        XCTAssert(getRandomInteger(maximum: 2, notAllowedInt: 1) != 1, "🍊🍊, getRandomInteger not ok")
    }
    
    func testExtractArrayElements() {
        XCTAssert([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].extractArrayElements(withStep: 1).count == 10, "🍊🍊, extractArrayElements not ok")
        XCTAssert([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].extractArrayElements(withStep: 5).count == 2, "🍊🍊, extractArrayElements not ok")
        XCTAssert([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].extractArrayElements(withStep: 5).count == 4, "🍊🍊, extractArrayElements not ok")
        XCTAssert(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"].extractArrayElements(withStep: 15).count == 2, "🍊🍊, extractArrayElements not ok")
    }
    
    // MARK: - Station Engine
    func testIsMaxAllowedVehicleNumberReached() {
        let stEngine = StationEngine()
        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: 10, maxAllowed: 10) == true, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: 9, maxAllowed: 10) == false, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: 3, maxAllowed: 10) == false, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: 11, maxAllowed: 10) == false, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
    }
}
