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
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    
    private enum CodingKeys: String, CodingKey {
            case Name, Description
        }
    
    init(name: String?, description: String?){ //optional values the have a default of blank
        Name = name ?? ""
        Description = description ?? ""
    }
        
    func addRow(db: OpaquePointer){
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, "insert into Club (name, description) values (?, ?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }

        if sqlite3_bind_text(statement, 1, "foo", -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 2, "bar", -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }

        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }
        statement = nil
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
        func getRow (db: OpaquePointer, Search: String){
            
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, "select id, name, description from Club where name = '\(Search)'", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                print("id = \(id); ", terminator: "")

                if let cString = sqlite3_column_text(statement, 1) {
                    let name = String(cString: cString)
                    print("name = \(name)")
                } else {
                    print("name not found")
                }
            }

            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }

            statement = nil
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

