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
//        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: 10, maxAllowed: 10) == true, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
//        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: 9, maxAllowed: 10) == false, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
//        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: 3, maxAllowed: 10) == false, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
//        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: 11, maxAllowed: 10) == false, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
    }
    
    func testGetRandomStation() {
        let stEngine = StationEngine()
        let st1 = Station(id: "11", name: "St 1", type: "bus", latitude: 0.0, longitude: 0.0)
        let st2 = Station(id: "22", name: "St 2", type: "bus", latitude: 0.0, longitude: 0.0)
        let st3 = Station(id: "33", name: "St 3", type: "bus", latitude: 0.0, longitude: 0.0)
        let st4 = Station(id: "44", name: "St 4", type: "bus", latitude: 0.0, longitude: 0.0)
        let st5 = Station(id: "55", name: "St 5", type: "bus", latitude: 0.0, longitude: 0.0)
        let stArray = [st1, st2, st3, st4, st5]
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: st1) != st1, "🍊🍊, getRandomStation not ok")
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: st2) != st2, "🍊🍊, getRandomStation not ok")
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: st3) != st3, "🍊🍊, getRandomStation not ok")
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: st4) != st4, "🍊🍊, getRandomStation not ok")
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: st5) != st5, "🍊🍊, getRandomStation not ok")
    }
    
    // MARK: - StatisticView
    func testGetKmFromM() {
        let statsView = StatisticView()
        XCTAssert(statsView.getKmFrom(meters: 1000) == "1.0 km", "🍊🍊, getRandomStation not ok")
        XCTAssert(statsView.getKmFrom(meters: 1000.00) == "1.0 km", "🍊🍊, getRandomStation not ok")
        XCTAssert(statsView.getKmFrom(meters: 1234) == "1.234 km", "🍊🍊, getRandomStation not ok")
        XCTAssert(statsView.getKmFrom(meters: 5422.3) == "5.4223 km", "🍊🍊, getRandomStation not ok")
    }
}
