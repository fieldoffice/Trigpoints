//
//  TrigpointsTests.swift
//  TrigpointsTests
//
//  Created by Michael Dales on 13/02/2022.
//

import XCTest
import CoreLocation

import ViewInspector

@testable import Trigpoints

extension PointListItem: Inspectable {}
extension AngleIndicator: Inspectable {}

class PointListItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPointListItemUnvisitedNoLocation() throws {
        let persistence = PersistenceController(inMemory: true)
        let point = TrigPoint(context: persistence.container.viewContext)
        point.name = "test"
        point.latitude = 60.0
        point.longitude = 0.1
        
        
        let subject = PointListItem(point: point, currentLocation: nil)
        
        let text = try subject.inspect().hStack().text(0).string()
        XCTAssert(text == point.name)
        XCTAssertThrowsError(try subject.inspect().find(AngleIndicator.self))
        XCTAssertThrowsError(try subject.inspect().find(viewWithTag: "checkmark"))
    }
    
    func testPointListItemUnvisitedWithLocation() throws {
        let persistence = PersistenceController(inMemory: true)
        let point = TrigPoint(context: persistence.container.viewContext)
        point.name = "test"
        point.latitude = 60.0
        point.longitude = 0.1
        let currentLocation = CLLocation(latitude: 60.1, longitude: 0.2)
        
        let subject = PointListItem(point: point, currentLocation: currentLocation)
        
        let text = try subject.inspect().hStack().text(0).string()
        XCTAssert(text == point.name)
        XCTAssertNoThrow(try subject.inspect().find(AngleIndicator.self))
        XCTAssertThrowsError(try subject.inspect().find(viewWithTag: "checkmark"))
    }
    
    func testPointListItemVisitedNoLocation() throws {
        let persistence = PersistenceController(inMemory: true)
        let point = TrigPoint(context: persistence.container.viewContext)
        point.name = "test"
        point.latitude = 60.0
        point.longitude = 0.1
        let visit = Visit(context: persistence.container.viewContext)
        visit.timestamp = Date()
        visit.point = point
        
        let subject = PointListItem(point: point, currentLocation: nil)
        
        let text = try subject.inspect().hStack().text(0).string()
        XCTAssert(text == point.name)
        XCTAssertThrowsError(try subject.inspect().find(AngleIndicator.self))
        XCTAssertNoThrow(try subject.inspect().find(viewWithTag: "checkmark"))
    }
    
    func testPointListItemVisitedWithLocation() throws {
        let persistence = PersistenceController(inMemory: true)
        let point = TrigPoint(context: persistence.container.viewContext)
        point.name = "test"
        point.latitude = 60.0
        point.longitude = 0.1
        let currentLocation = CLLocation(latitude: 60.1, longitude: 0.2)
        let visit = Visit(context: persistence.container.viewContext)
        visit.timestamp = Date()
        visit.point = point
        
        let subject = PointListItem(point: point, currentLocation: currentLocation)
        
        let text = try subject.inspect().hStack().text(0).string()
        XCTAssert(text == point.name)
        XCTAssertNoThrow(try subject.inspect().find(AngleIndicator.self))
        XCTAssertNoThrow(try subject.inspect().find(viewWithTag: "checkmark"))
    }

}
