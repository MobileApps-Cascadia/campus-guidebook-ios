//
//  DatabaseHelper.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 4/26/22.
//

import Foundation
import SQLite3


class DataBaseHelper {
    
    var db: OpaquePointer? // db refrance
    var path: String = "AppDatabase.sqlite"// db path
    
    init(){
        self.db = CreateDB()
        self.CreateTable()
    }
    
    
    func CreateDB() -> OpaquePointer?{ //make a database file at this location. if it fails, print result
        let FilePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(FilePath.path, &db) != SQLITE_OK{
            print("sqlite did not open")
            return nil
        }else{
            print("sqlite did open from path \(path)")
            return db
        }
    }
    
    func CreateTable(){
        let CreateClubTable: String = "CREATE TABLE IF NOT EXISTS Club (id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Description TEXT);" //create the Clubs table
        let CreateEventsTable: String = "CREATE TABLE IF NOT EXISTS Event (id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Description TEXT, Time TEXT, Date TEXT);" //create the Event table
        let CreateSustainabilityTable: String = "CREATE TABLE IF NOT EXISTS Sustainability (id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Description TEXT);" //create the Sustainability table
        initTable(table: CreateClubTable, name: "Club")
        initTable(table: CreateEventsTable, name: "Event")
        initTable(table: CreateSustainabilityTable, name: "Sustainability")
        
    }
    func initTable(table: String, name: String){
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, table, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("\(name) table has been created successfuly")
            }else{
                print("\(name) table creation fail")
            }
        }else{
            print("\(name) table prep fail \(SQLITE_ERROR)")
        }
    }
}
