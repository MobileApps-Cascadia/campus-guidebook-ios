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
    var Name: String
    var Description: String
    var db = DataBaseHelper()// get the database
    
    init(name: String?, description: String?){ //optional values the have a default of blank
        Name = name ?? ""
        Description = description ?? ""
    }
    
    func addLine(){
        let ValueString: String = "\(Name), \(Description)"
        
        let insertStatementString = "INSERT INTO \(TableName) (\(Tablecolumns)) VALUES (\(ValueString));"
        
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
    }

