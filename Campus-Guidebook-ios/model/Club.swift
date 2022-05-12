//
//  Club.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 4/30/22.
//

import Foundation
import SQLite3


class Club: Codable{
    var TableName: String = "Club"//track the table in which the dao is refering to for genaric queries
    var Tablecolumns: String = "Name, Discription"//track values in columns in the table for queries
    var Name: String = ""
    var Description: String = ""
    
    
    private enum CodingKeys: String, CodingKey {
            case Name, Description
        }
    
    init(name: String?, description: String?){ //optional values the have a default of blank
        Name = name ?? ""
        Description = description ?? ""
    }
        
    func addRow(db: DataBaseHelper){
            let ValueString: String = "\(Name), \(Description)"
            
            let insertStatementString = "INSERT INTO \(TableName) (\(Tablecolumns)) VALUES (\(ValueString));"
            
            var insertStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                  SQLITE_OK {
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                  print("\nSuccessfully inserted row.")
                } else {
                  print("\nCould not insert row.")
                }
              } else {
                print("\nINSERT statement is not prepared.")
              }
              
              sqlite3_finalize(insertStatement)
            }
        func removeRowByID(db: DataBaseHelper, Search: String, id: Int){
            
            
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
              
              sqlite3_finalize(insertStatement)
        }
        func getRow (db: DataBaseHelper, Search: String){
            
    
            let insertStatementString = "Select * FROM \(TableName) WHERE Name LIKE '\(Search)';"
    
            var queryStatement: OpaquePointer?
    
            if sqlite3_prepare_v2(db.db, insertStatementString, -1, &queryStatement, nil) ==
                  SQLITE_OK {
                if sqlite3_step(queryStatement) == SQLITE_ROW {
    
                  let id = sqlite3_column_int(queryStatement, 0)
    
                  guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    return
                  }
                  let name = String(cString: queryResultCol1)
                  print("Query Result:")
                  print("\(id) | \(name)")
              } else {
                  print("Query returned no results.")
              }
              } else {
                  
                  let errorMessage = String(cString: sqlite3_errmsg(db.db))
                print("Query is not prepared \(errorMessage)")
              }
              
              sqlite3_finalize(queryStatement)
        }
//    func query(db: DataBaseHelper, Search: String) {
//          var queryStatement: OpaquePointer?
//          let insertStatementString = "SELECT * FROM \(TableName) WHERE Name MATCH '\(Search)';"
//
//          if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
//              SQLITE_OK {
//
//            if sqlite3_step(queryStatement) == SQLITE_ROW {
//
//              let id = sqlite3_column_int(queryStatement, 0)
//
//              guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
//                print("Query result is nil")
//                return
//              }
//              let name = String(cString: queryResultCol1)
//
//              print("\nQuery Result:")
//              print("\(id) | \(name)")
//          } else {
//              print("\nQuery returned no results.")
//          }
//          } else {
//
//            let errorMessage = String(cString: sqlite3_errmsg(db))
//            print("\nQuery is not prepared \(errorMessage)")
//          }
//
//          sqlite3_finalize(queryStatement)
//        }
//
//    }

    }

