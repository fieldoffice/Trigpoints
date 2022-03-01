//
//  NearbyPointsUITests.swift
//  TrigpointsUITests
//
//  Created by Michael Dales on 01/03/2022.
//

import XCTest

class NearbyPointsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicView() throws {
        let app = XCUIApplication()
        app.launchArguments = [kUITestingFlag]
        app.launch()
        
        XCTAssertTrue(app.staticTexts["Active station"].exists)
        XCTAssertTrue(app.staticTexts["Glasgow"].exists)
        
        app.staticTexts["Glasgow"].tap()
        
        XCTAssertTrue(app.staticTexts["Glasgow"].exists)
        XCTAssertTrue(app.staticTexts["You have not visited here yet!"].exists)
    }

}
