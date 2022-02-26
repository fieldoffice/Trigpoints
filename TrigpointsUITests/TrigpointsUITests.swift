//
//  TrigpointsUITests.swift
//  TrigpointsUITests
//
//  Created by Michael Dales on 13/02/2022.
//

import XCTest

class TrigpointsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClearAppStart() throws {
        let app = XCUIApplication()
        app.resetAuthorizationStatus(for: .location)
        app.launch()
        
        // On launch we should have no permissions, so we should see the button
        // requesting them.
        XCTAssertTrue(app.buttons["Allow location access"].exists)
        XCTAssertFalse(app.staticTexts["You've not visited any points yet!"].exists)
        
        // But the tab bar should still work, just we have no state
        app.staticTexts["Visited"].tap()
        XCTAssertFalse(app.buttons["Allow location access"].exists)
        XCTAssertTrue(app.staticTexts["You've not visited any points yet!"].exists)
        
        // and back again...
        app.staticTexts["Nearby"].tap()
        XCTAssertTrue(app.buttons["Allow location access"].exists)
        XCTAssertFalse(app.staticTexts["You've not visited any points yet!"].exists)
    }
    
    func testRejectLocationRequest() throws {
        let app = XCUIApplication()
        app.resetAuthorizationStatus(for: .location)
        app.launch()
        
        app.buttons["Allow location access"].tap()
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let button = springboard.alerts.firstMatch.buttons["Don’t Allow"]
        if button.waitForExistence(timeout: 10) {
            button.tap()
        }

        XCTAssertFalse(app.buttons["Allow location access"].exists)
        XCTAssertTrue(app.staticTexts["The app does not have location permissions, so can't show nearby trig points. Please enable them in settings."].exists)
    }
    
    func testAcceptLocationRequest() throws {
        let app = XCUIApplication()
        app.resetAuthorizationStatus(for: .location)
        app.launch()
        
        app.buttons["Allow location access"].tap()
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let button = springboard.alerts.firstMatch.buttons["Allow Once"]
        if button.waitForExistence(timeout: 10) {
            button.tap()
        }

        XCTAssertFalse(app.buttons["Allow location access"].exists)
        XCTAssertFalse(app.staticTexts["The app does not have location permissions, so can't show nearby trig points. Please enable them in settings."].exists)
    }
}
