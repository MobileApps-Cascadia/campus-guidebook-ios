//
//  GenaricDBMethods.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 5/6/22.
//

import Foundation
import SQLite3
class DatabaseCalls{
    var db = DataBaseHelper()// get the database
    
    
    func addRow(obj: <This needs to accept Club, Event, And Sustainability objects>, param: String){
        let ValueString: String = "\(obj.Name), \(obj.Description)"
        
        let insertStatementString = "INSERT INTO \(obj.TableName) (\(obj.Tablecolumns)) VALUES (\(ValueString));"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db.db, insertStatementString, -1, &insertStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
              print("\nSuccessfully inserted row.")
            } else {
              print("\nCould not insert row.")
            }
          } else {
            print("\nINSERT statement is not prepared.")
          }
          // 5
          sqlite3_finalize(insertStatement)
        }
    func removeRowByID(Search: String, id: Int){
        let ValueString: String = "\(Name), \(Description)"
        
        let insertStatementString = "DELETE FROM \(TableName) WHERE id LIKE '\(id)';"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db.db, insertStatementString, -1, &insertStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
              print("\nSuccessfully Deleted.")
            } else {
              print("\nCould not Delete. id = \(id) may not exist")
            }
          } else {
            print("Delete statement is not prepared.")
          }
          // 5
          sqlite3_finalize(insertStatement)
    }
//    func getRow (Search: String){
//        let ValueString: String = "\(Name), \(Description)"
//
//        let insertStatementString = "Select * FROM \(TableName) WHERE Name LIKE '\(Search)';"
//
//        var insertStatement: OpaquePointer?
//
//        if sqlite3_prepare_v2(db.db, insertStatementString, -1, &insertStatement, nil) ==
//              SQLITE_OK {
//            if sqlite3_step(queryStatement) == SQLITE_ROW {
//
//              let id = sqlite3_column_int(queryStatement, 0)
//
//              guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
//                print("Query result is nil")
//                return
//              }
//              let name = String(cString: queryResultCol1)
//              print("Query Result:")
//              print("\(id) | \(name)")
//          } else {
//              print("Query returned no results.")
//          }
//          } else {
//              // 6
//            let errorMessage = String(cString: sqlite3_errmsg(db))
//            print("Query is not prepared \(errorMessage)")
//          }
//          // 7
//          sqlite3_finalize(queryStatement)
//    }
    func query() {
      var queryStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
          SQLITE_OK {
        // 2
        if sqlite3_step(queryStatement) == SQLITE_ROW {
          // 3
          let id = sqlite3_column_int(queryStatement, 0)
          // 4
          guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
            print("Query result is nil")
            return
          }
          let name = String(cString: queryResultCol1)
          // 5
          print("\nQuery Result:")
          print("\(id) | \(name)")
      } else {
          print("\nQuery returned no results.")
      }
      } else {
          // 6
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("\nQuery is not prepared \(errorMessage)")
      }
      // 7
      sqlite3_finalize(queryStatement)
    }
    
}
