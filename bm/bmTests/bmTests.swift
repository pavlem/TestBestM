//
//  bmTests.swift
//  bmTests
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import XCTest
import MapKit
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
        let vehicle1 = Vehicle(id: "", name: "", image: UIImage(), latitude: 0.0, longitude: 0.0, route: [CLLocationCoordinate2D()], polyline: MKPolyline(), distance: 0.0)
        let vehicle2 = Vehicle(id: "", name: "", image: UIImage(), latitude: 0.0, longitude: 0.0, route: [CLLocationCoordinate2D()], polyline: MKPolyline(), distance: 0.0)
        let vehicle3 = Vehicle(id: "", name: "", image: UIImage(), latitude: 0.0, longitude: 0.0, route: [CLLocationCoordinate2D()], polyline: MKPolyline(), distance: 0.0)
        let vehicles = [vehicle1, vehicle2, vehicle3]
        stEngine.vehicles = vehicles
        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(maxAllowed: 10) == false, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(maxAllowed: 3) == true, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(maxAllowed: 4) == false, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
        XCTAssert(stEngine.isMaxAllowedVehicleNumberReached(maxAllowed: 2) == true, "🍊🍊, isMaxAllowedVehicleNumberReached not ok")
    }
    
    func getArrayOfStations() -> [Station] {
        let st1 = Station(id: "11", name: "St 1", type: "bus", latitude: 0.0, longitude: 0.0)
        let st2 = Station(id: "22", name: "St 2", type: "bus", latitude: 0.0, longitude: 0.0)
        let st3 = Station(id: "33", name: "St 3", type: "bus", latitude: 0.0, longitude: 0.0)
        let st4 = Station(id: "44", name: "St 4", type: "bus", latitude: 0.0, longitude: 0.0)
        let st5 = Station(id: "55", name: "St 5", type: "bus", latitude: 0.0, longitude: 0.0)
        return [st1, st2, st3, st4, st5]
    }
    
    func testGetRandomStation() {
        let stEngine = StationEngine()
        let stArray = getArrayOfStations()
        stEngine.set(stations: stArray)

        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: stArray[0]) != stArray[0], "🍊🍊, getRandomStation not ok")
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: stArray[1]) != stArray[1], "🍊🍊, getRandomStation not ok")
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: stArray[2]) != stArray[2], "🍊🍊, getRandomStation not ok")
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: stArray[3]) != stArray[3], "🍊🍊, getRandomStation not ok")
        XCTAssert(stEngine.getRandomStation(fromStations: stArray, excludingStation: stArray[4]) != stArray[4], "🍊🍊, getRandomStation not ok")
    }

    
    // MARK: - StatisticView
    func testGetKmFromM() {
        let statsView = StatisticView()
        XCTAssert(statsView.getKmFrom(meters: 1000) == "1.0 km", "🍊🍊, getKmFrom not ok")
        XCTAssert(statsView.getKmFrom(meters: 1000.00) == "1.0 km", "🍊🍊, getKmFrom not ok")
        XCTAssert(statsView.getKmFrom(meters: 1234) == "1.234 km", "🍊🍊, getKmFrom not ok")
        XCTAssert(statsView.getKmFrom(meters: 5422.3) == "5.4223 km", "🍊🍊, getKmFrom not ok")
    }
    
    // MARK: - ParserHelper
    func getStationDictionaryData() -> [Any]? {
        let path = Bundle.main.path(forResource: "stationMOCList", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let jsonResultDict = jsonResult as? Dictionary<String, AnyObject>
        return jsonResultDict!["stationData"] as? [Any]
    }
    
    func testParseDictionaryToRealmStationObjects() {
        let stationDictionaryData = getStationDictionaryData()
        let stationsRealm = ParserHelper.parseDictionaryToRealmObject(stationData: stationDictionaryData!)
        XCTAssert(stationsRealm.count == 5, "🍊🍊, parseDictionaryToRealmObject count not ok")
    }
    
    func testParseDictionaryToStationObjects() {
        let stationDictionaryData = getStationDictionaryData()
        let stationsRealm = ParserHelper.parseDict(stationData: stationDictionaryData!)
        XCTAssert(stationsRealm.count == 5, "🍊🍊, testParseDictionaryToStationObjects count not ok")
    }
}
