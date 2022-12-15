//
//  Sustainability.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 4/30/22.
//

import Foundation
import SQLite3
class Sustainability: Codable{
    var TableName: String = "Sustainability"//Tracks the table in which the dao is refering to for genaric queries
    var TableColumns: String = "name, description, ImageURL, Location"//Tracks columns in the table for queries
    var InsertableValueCount: Int = 4 //Change this when you add a new column
    var Name: String
    var Description: String
    var ImageURL: String //Add variables here when you add a new column
    var Location: String
    
    
    
    private enum CodingKeys: String, CodingKey {
            case Name, Description, ImageURL, Location
        }
    
    init(name: String?, description: String?, imageURL: String?, location: String?){ //Optional values have a default of blank //Change this when you add a new column
        Name = name ?? ""
        Description = description ?? ""
        ImageURL = imageURL ?? "" //Add variables here when you add a new column
        Location = location ?? ""
    }
}
