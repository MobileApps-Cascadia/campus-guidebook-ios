////
////  Campus_Guidebook_iosTests.swift
////  Campus-Guidebook-iosTests
////
////  Created by Student Account on 4/26/22.
////
//
//import XCTest
//@testable import Campus_Guidebook_ios
//
//class Campus_Guidebook_iosTests: XCTestCase {
//    var dbase: DataBaseHelper
//    var conn: OpaquePointer
//    var mClub: Club
//    var mEvent: Event
//    var mSustainability: Sustainability
//    var results: [Any] = ["hi"]
//
//    override init(){
//
//        self.dbase = DataBaseHelper()
//        self.conn = dbase.GetOpenDB()
//        mEvent = Event(name: "Event TestName", description: "Test Event description")
//        mClub = Club(name: "Club TestName", description: "Test Club description")
//        mSustainability = Sustainability(name: "Sustainability TestName", description: "Test Sustainability description")
//        super.init()
//    }
//
//    override func setUp() {
//         //link databse here
//
//
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        dbase.RemoveDBTables()
//
//    }
//
//
//    func test3TableAdd() throws {
//        mEvent.addRow(db: conn)
//        results = mEvent.getRow(db: conn, Search: "Event TestName")
//        XCTAssertEqual(results[0] as? NSString, "Event TestName")
//        mClub.addRow(db: conn)
//        results = mClub.getRow(db: conn, Search: "Club TestName")
//        XCTAssertEqual(results[0] as? NSString, "Club TestName")
//        mSustainability.addRow(db: conn)
//        results = mSustainability.getRow(db: conn, Search: "Sustainability TestName")
//        XCTAssertEqual(results[0] as? NSString, "Sustainability TestName")
//    }
//    func test3TableRemove() throws {
//        mEvent.addRow(db: conn)
//        mEvent.removeRowByID(db: conn, id: 1)
//        results = mEvent.getRow(db: conn, Search: "Event TestName")
//        XCTAssertEqual(results[0] as? NSInteger, 2)
//        mClub.addRow(db: conn)
//        mClub.removeRowByID(db: conn, id: 1)
//        results = mEvent.getRow(db: conn, Search: "Club TestName")
//        XCTAssertEqual(results[0] as? NSInteger, 2)
//        mSustainability.addRow(db: conn)
//        mSustainability.removeRowByID(db: conn, id: 1)
//        results = mEvent.getRow(db: conn, Search: "Sustainability TestName")
//        XCTAssertEqual(results[0] as? NSInteger, 2)
//    }
//    func testGetAllTests() throws {
//        mClub.addRow(db: conn)
//        mClub.addRow(db: conn)
//        mClub.addRow(db: conn)
//        results = dbase.getAllTableContents(tablename: "Club")
//        XCTAssertTrue(results.count > 2)
//        mEvent.addRow(db: conn)
//        mEvent.addRow(db: conn)
//        mEvent.addRow(db: conn)
//        results = dbase.getAllTableContents(tablename: "Event")
//        XCTAssertTrue(results.count > 2)
//        mSustainability.addRow(db: conn)
//        mSustainability.addRow(db: conn)
//        mSustainability.addRow(db: conn)
//        results = dbase.getAllTableContents(tablename: "Sustainability")
//        XCTAssertTrue(results.count > 2)
//    }
//}
