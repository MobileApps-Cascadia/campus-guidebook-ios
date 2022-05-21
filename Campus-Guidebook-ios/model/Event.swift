//
//  Event.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 4/30/22.
//

import Foundation
import SQLite3
class Event: Codable{
    var TableName: String = "Event"//track the table in which the dao is refering to for genaric queries
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
        
    

    }
