//
//  Event.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 4/30/22.
//

import Foundation
import SQLite3
class Event: Codable{
    var TableName: String = "Event"//Tracks the table in which the dao is refering to for genaric queries
    var TableColumns: String = "name, description, ImageURL, StartDate, StartTime, CreationDate, Location, ContactURL"//Tracks columns in the table for queries
    var InsertableValueCount: Int = 8 //Change this when you add a new column
    var Name: String
    var Description: String
    var ImageURL: String //Add variables here when you add a new column
    var StartDate: String
    var StartTime: String
    var CreationDate: String
    var Location: String
    var ContactURL: String

    
    
    private enum CodingKeys: String, CodingKey {
            case Name, Description, ImageURL, StartDate, StartTime, CreationDate, Location, ContactURL
        }
    
    init(name: String?, description: String?, imageURL: String?, startDate: String?, startTime: String?, creationDate: String?, location: String?, contactURL: String?){ //Optional values have a default of blank //Change this when you add a new column
        Name = name ?? ""
        Description = description ?? ""
        ImageURL = imageURL ?? "" //Add variables here when you add a new column
        StartDate = startDate ?? ""
        StartTime = startTime ?? ""
        CreationDate = creationDate ?? ""
        Location = location ?? ""
        ContactURL = contactURL ?? ""
    }
        
    

    }
