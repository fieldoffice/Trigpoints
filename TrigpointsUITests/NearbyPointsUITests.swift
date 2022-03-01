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

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launchArguments = [kUITestingFlag]
        app.launch()
        
        XCTAssertTrue(app.staticTexts["Glasgow"].exists)
    }

}
