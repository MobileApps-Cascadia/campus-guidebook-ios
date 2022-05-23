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
    var TableColumns: String = "name, description, image"//track values in columns in the table for queries
    var InsertableValueCount: Int = 3 //change this when you add a new column
    var Name: String
    var Description: String
    var Image: String// add stuff here when you add a new column
    
    
    
    private enum CodingKeys: String, CodingKey {
            case Name, Description, Image
        }
    
    init(name: String?, description: String?, image: String?){ //optional values the have a default of blank //change this when you add a new column
        Name = name ?? ""
        Description = description ?? ""
        Image = image ?? ""// add stuff here when you add a new column
    }
}
