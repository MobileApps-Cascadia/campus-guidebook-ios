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

    override func setUp() {
         //link databse here
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dbase.RemoveDBTables()
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
