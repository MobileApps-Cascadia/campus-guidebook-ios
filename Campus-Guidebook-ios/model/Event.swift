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
    var TableColumns: String = "name, description"//track values in columns in the table for queries
    var InsertableValueCount: Int = 2
    
    var Name: String
    var Description: String
    
    
    
    private enum CodingKeys: String, CodingKey {
            case Name, Description
        }
    
    init(name: String?, description: String?){ //optional values the have a default of blank
        Name = name ?? ""
        Description = description ?? ""
    }
        
    

    }
