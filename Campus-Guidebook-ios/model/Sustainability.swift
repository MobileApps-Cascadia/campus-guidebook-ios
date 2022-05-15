//
//  Sustainability.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 4/30/22.
//

import Foundation
import SQLite3
class Sustainability: Codable{
    var TableName: String = "Sustainability"//track the table in which the dao is refering to for genaric queries
    var Tablecolumns: String = "name, description"//track values in columns in the table for queries
    
    var Name: String
    var Description: String
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
        //var t: String =

        if sqlite3_prepare_v2(db, "insert into \(TableName) (\(Tablecolumns)) values (?, ?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }

        if sqlite3_bind_text(statement, 1, Name, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 2, Description, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }

        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }
        statement = nil
            }
        func removeRowByID(db: OpaquePointer, id: Int){
            
            
            let insertStatementString = "DELETE FROM \(TableName) WHERE id LIKE '\(id)';"
            
            var insertStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
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
    func getRow (db: OpaquePointer, Search: String) -> Array<Any>{
        
        var Array: [Any] = []
        var SubArray: [Any] = []
            
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, "select id, name, description from \(TableName) where name = '\(Search)'", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                print("id = \(id); ", terminator: "")

                if let cString = sqlite3_column_text(statement, 1) {
                    let name = String(cString: cString)
                    print("name = \(name)")
                    if let cString = sqlite3_column_text(statement, 2) {
                        let description = String(cString: cString)
                        print("description = \(description)")
                        
                        SubArray.append(id)
                        SubArray.append(name)
                        SubArray.append(description)
                        Array.append(SubArray)
                        SubArray = []
                    } else {
                        print("description not found")
                    }

                } else {
                    print("name not found")
                }
            }

            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
        
            statement = nil
            return Array
        }

    }
