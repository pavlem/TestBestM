//
//  bmUITests.swift
//  bmUITests
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import XCTest

class bmUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIfFetchStationBtnExists() {
        let btn = app.buttons[UITestMainVC.fetchStationsBtn]
        XCTAssert(btn.exists == true, "🔥🔥 testFetchStations btn does not exist")
    }
    
    func testIfCreateExists() {
        login()
        let createBtn = app.buttons[UITestMapVC.createBarBtn]
        XCTAssert(createBtn.exists == true, "🔥🔥 backBtn btn does not exist")
    }
    
    func testIfStatsExists() {
        login()
        let statsBtn = app.buttons[UITestMapVC.statsBarBtn]
        XCTAssert(statsBtn.exists == true, "🔥🔥 backBtn btn does not exist")
    }

    func testFetchStationsAndGoback() {
        login()
        let backBtn = app.buttons[UITestMapVC.backBarBtn]
        XCTAssert(backBtn.exists == true, "🔥🔥 backBtn btn does not exist")
        backBtn.tap()
    }
    
    func testStastBarBtnActionsAndStastisticsView() {
        login()
        
        let statsBtn = app.buttons[UITestMapVC.statsBarBtn]
        statsBtn.tap()
        sleep(1)
        let statsView = app.otherElements[UITestMapVC.statsView]
        XCTAssert(statsView.exists == true, "🔥🔥 statsView btn does not exist")
        statsBtn.tap()
        XCTAssert(statsView.exists == false, "🔥🔥 statsView does not exist")
    }
    
    // MARK: - Helper functions
    private func login() {
        let btn = app.buttons[UITestMainVC.fetchStationsBtn]
        XCTAssert(btn.exists == true, "🔥🔥 testFetchStations btn does not exist")
        btn.tap()
        sleep(1)
    }
}
