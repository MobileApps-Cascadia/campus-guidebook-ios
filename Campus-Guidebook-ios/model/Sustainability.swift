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
    var TableColumns: String = "name, description, ImageURL, Location"//track values in columns in the table for queries
    var InsertableValueCount: Int = 4 //change this when you add a new column
    var Name: String
    var Description: String
    var ImageURL: String// add stuff here when you add a new column
    var Location: String
    
    
    
    private enum CodingKeys: String, CodingKey {
            case Name, Description, ImageURL, Location
        }
    
    init(name: String?, description: String?, imageURL: String?, location: String?){ //optional values the have a default of blank //change this when you add a new column
        Name = name ?? ""
        Description = description ?? ""
        ImageURL = imageURL ?? ""// add stuff here when you add a new column
        Location = location ?? ""
    }
}
