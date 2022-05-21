//
//  Campus_Guidebook_iosTests.swift
//  Campus-Guidebook-iosTests
//
//  Created by Student Account on 4/26/22.
//

import XCTest
@testable import Campus_Guidebook_ios

class Campus_Guidebook_iosTests: XCTestCase {
    let dbase: DataBaseHelper = DataBaseHelper()
    let conn: OpaquePointer = dbase.GetOpenDB()
    var mClub
    var mEvent
    var mSustainability
    var results = []

    override func setUp() {
         //link databse here
    mEvent: Event = Event(name: "Event TestName", description: "Test Event description")
    mClub: Club = Club(name: "Club TestName", description: "Test Club description")
    mSustainability: Sustainability = Sustainability(name: "Sustainability TestName", description: "Test Sustainability description")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dbase.RemoveDBTables()
        
    }

    
    func test3TableAdd() throws {
        mEvent.addRow(db: conn)
        results = mEvent.getRow(db: conn, Search: "Event TestName")
        XCTAssertEqual(results[0][1], "Event TestName")
        mClub.addRow(db: conn)
        results = mClub.getRow(db: conn, Search: "Club TestName")
        XCTAssertEqual(results[0][1], "Club TestName")
        mSustainability.addRow(db: conn)
        results = mSustainability.getRow(db: conn, Search: "Sustainability TestName")
        XCTAssertEqual(results[0][1], "Sustainability TestName")
    }
    func test3TableRemove() throws {
        mEvent.addRow(db: conn)
        mEvent.removeRowByID(db: conn, id: 1)
        results = mEvent.getRow(db: conn, Search: "Event TestName")
        XCTAssertEqual(results[0][0], 2)
        mClub.addRow(db: conn)
        mClub.removeRowByID(db: conn, id: 1)
        results = mEvent.getRow(db: conn, Search: "Club TestName")
        XCTAssertEqual(results[0][0], 2)
        mSustainability.addRow(db: conn)
        mSustainability.removeRowByID(db: conn, id: 1)
        results = mEvent.getRow(db: conn, Search: "Sustainability TestName")
        XCTAssertEqual(results[0][0], 2)
    }
}
