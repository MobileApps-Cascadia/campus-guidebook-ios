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
    var TableColumns: String = "name, description, ImageURL, StartDate, StartTime, CreationDate, Location, ContactURL, SubscriptionsCounter"//track values in columns in the table for queries
    var InsertableValueCount: Int = 9 //change this when you add a new column //TODO: Check if this is required
    var Name: String
    var Description: String
    var ImageURL: String// add stuff here when you add a new column
    var StartDate: String
    var StartTime: String
    var CreationDate: String
    var Location: String
    var ContactURL: String
    var SubscriptionsCounter: String

    
    
    private enum CodingKeys: String, CodingKey {
            case Name, Description, ImageURL, StartDate, StartTime, CreationDate, Location, ContactURL, SubscriptionsCounter
        }
    
    init(name: String?, description: String?, imageURL: String?, startDate: String?, startTime: String?, creationDate: String?, location: String?, contactURL: String?, subscriptionsCounter: String?){ //optional values the have a default of blank //change this when you add a new column
        Name = name ?? ""
        Description = description ?? ""
        ImageURL = imageURL ?? ""// add stuff here when you add a new column
        StartDate = startDate ?? ""
        StartTime = startTime ?? ""
        CreationDate = creationDate ?? ""
        Location = location ?? ""
        ContactURL = contactURL ?? ""
        SubscriptionsCounter = subscriptionsCounter ?? "0"
    }
        
    

    }
