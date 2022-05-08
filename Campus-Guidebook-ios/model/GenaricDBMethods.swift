//
//  GenaricDBMethods.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 5/6/22.
//

import Foundation
import SQLite3
class GenaricDBMethods: Codable {
    
    func addRow(){
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
