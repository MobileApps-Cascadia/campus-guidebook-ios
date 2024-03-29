//
//  DatabaseHelper.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 4/26/22.
//

import Foundation
import SQLite3


class DatabaseHelper {
    
    private var db: OpaquePointer? // db refrance
    private var path: String = "AppDatabase.sqlite"// db path
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    init(){
        self.db = CreateDB()
        self.CreateTable()
        
    }
    
    
    private func CreateDB() -> OpaquePointer?{ //Make a database file at this location. if it fails, print result.
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
        let CreateClubTable: String = "CREATE TABLE IF NOT EXISTS Club (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, ImageURL TEXT, StartDate TEXT, StartTime TEXT, CreationDate TEXT, Location TEXT, ContactURL TEXT);" //Create the Clubs table
        let CreateEventsTable: String = "CREATE TABLE IF NOT EXISTS Event (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, ImageURL TEXT, StartDate TEXT, StartTime TEXT, CreationDate TEXT, Location TEXT, ContactURL TEXT, SubscriptionsCounter TEXT);" //Create the Event table
        let CreateSustainabilityTable: String = "CREATE TABLE IF NOT EXISTS Sustainability (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, ImageURL TEXT, Location TEXT);" //Create the Sustainability table
        initTable(table: CreateClubTable, name: "Club")
        initTable(table: CreateEventsTable, name: "Event")
        initTable(table: CreateSustainabilityTable, name: "Sustainability")
        
    }
    private func initTable(table: String, name: String){
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
    func getAllTableContents(tablename: String) -> [[String]]{
        var rArray = [[String]]()
        var subarray = [String]()
        var i: Int32 = 0
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "select * from \(tablename)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            while (sqlite3_column_text(statement, i) != nil){
                guard let queryResultCol = sqlite3_column_text(statement, i) else {
                    print("Query result is nil")
                    return [[]]
                }
                var item = String(cString: queryResultCol)
                
                subarray.append(item)
                i = i + 1
            }
            i = 0
            rArray.append(subarray)
            subarray = []
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        return rArray
        
    }
    
    
    func GetOpenDB() -> OpaquePointer{ //This method will return the activated database connection to use in objects
        return db!
        
    }
    
    
    
    
    func addClubRow(Club: Club?){
        var statement: OpaquePointer?
        var i: Int = 0
        var valueString: String = ""
        
        
        if (Club != nil){
            let mClub: Club = Club!
            let columnArray = [mClub.Name, mClub.Description, mClub.ImageURL, mClub.StartDate, mClub.StartTime, mClub.CreationDate, mClub.Location, mClub.ContactURL] //Add new values here when you add another column to the table.
            while (i < mClub.InsertableValueCount){ //Auto-building the string of values based on the number of potental values in the spicific table.
                if (i == 0){
                    valueString = "?"
                }
                else{
                    valueString = valueString + ", ?"
                }
                i = i + 1
            }
            i = 0
            print("insert into \(mClub.TableName) (\(mClub.TableColumns)) values (\(valueString))")
            if sqlite3_prepare_v2(db, "insert into \(mClub.TableName) (\(mClub.TableColumns)) values (\(valueString))", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            var valIndex: Int32 = 1
            while (i < columnArray.count)
            {
                if sqlite3_bind_text(statement, valIndex, columnArray[i], -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                }
                valIndex = valIndex + 1
                i = i + 1
            }
            
            
            i = 0
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }
        statement = nil
    }
    
    func addEventRow(Event: Event?){
        var statement: OpaquePointer?
        var i: Int = 0
        var valueString: String = ""
        
        
        if (Event != nil){
            let mEvent: Event = Event!
            let columnArray = [mEvent.Name, mEvent.Description, mEvent.ImageURL, mEvent.StartDate, mEvent.StartTime, mEvent.CreationDate, mEvent.Location, mEvent.ContactURL, mEvent.SubscriptionsCounter] //Add new values here when you add another column to the table.
            while (i < mEvent.InsertableValueCount){ //Auto-building the string of values based on the number of potental values in the spicific table.
                if (i == 0){
                    valueString = "?"
                }
                else{
                    valueString = valueString + ", ?"
                }
                i = i + 1
            }
            i = 0
            print("insert into \(mEvent.TableName) (\(mEvent.TableColumns)) values (\(valueString))")
            if sqlite3_prepare_v2(db, "insert into \(mEvent.TableName) (\(mEvent.TableColumns)) values (\(valueString))", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            var valIndex: Int32 = 1
            while (i < columnArray.count)
            {
                if sqlite3_bind_text(statement, valIndex, columnArray[i], -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                }
                valIndex = valIndex + 1
                i = i + 1
            }
            
            
            i = 0
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }
        statement = nil
    }
    
    func getEventSubscriberCount(tableName: String, id: Int) -> String {
        var statement: OpaquePointer?
        var result: String?

        // Prepare the query using a parameterized statement
        let query = "select SubscriptionsCounter from \(tableName) WHERE id = '\(id)';"

        // getting the subscription counter
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        // Bind the parameter to the query
        if sqlite3_bind_int(statement, 1, 1) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding parameter: \(errmsg)")
        }


        if sqlite3_step(statement) == SQLITE_ROW {
            guard let queryResultCol = sqlite3_column_text(statement, 0) else {
                print("Query result is nil")
                return ""
            }
            result = String(cString: queryResultCol)

        } else {
            print("Query returned no results.")
        }
        sqlite3_finalize(statement)
        return result!
    }
    
    func manageSubscription(counter: String, id: Int) {
        var statement: OpaquePointer?
        
        // increase subscription counter
        if sqlite3_prepare_v2(db, "UPDATE Event SET SubscriptionsCounter = '\(counter)' WHERE id = '\(id)';", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        sqlite3_bind_text(statement, 1, counter, -1, SQLITE_TRANSIENT)
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("\nSuccessfully inserted row.")
                } else {
                  print("\nCould not insert row.")
                }
    }
    
    func addSustainabilityRow(Sustainability: Sustainability?){
        var statement: OpaquePointer?
        var i: Int = 0
        var valueString: String = ""
        
        if (Sustainability != nil){
            let mSustainability: Sustainability = Sustainability!
            let columnArray = [mSustainability.Name, mSustainability.Description, mSustainability.ImageURL, mSustainability.Location] //Add new values here when you add another column to the table.
            while (i < mSustainability.InsertableValueCount){ //Auto-building the string of values based on the number of potental values in the spicific table.
                if (i == 0){
                    valueString = "?"
                }
                else{
                    valueString = valueString + ", ?"
                }
                i = i + 1
            }
            i = 0
            print("insert into \(mSustainability.TableName) (\(mSustainability.TableColumns)) values (\(valueString))")
            if sqlite3_prepare_v2(db, "insert into \(mSustainability.TableName) (\(mSustainability.TableColumns)) values (\(valueString))", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            var valIndex: Int32 = 1
            while (i < columnArray.count)
            {
                if sqlite3_bind_text(statement, valIndex, columnArray[i], -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                }
                valIndex = valIndex + 1
                i = i + 1
            }
            
            
            i = 0
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }
        statement = nil
    }
    
    
    func removeRowByID(tableName: String, id: Int){
        
        
        let insertStatementString = "DELETE FROM \(tableName) WHERE id LIKE '\(id)';"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully Deleted.")
            } else {
                print("\nCould not Delete. id = \(id) may not exist")
            }
        } else {
            print("Delete statement is not prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    func getRowByName (tableName: String, Search: String) -> [[String]]{
        
        var rArray = [[String]]()
        var subarray = [String]()
        var i: Int32 = 0
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "select * from \(tableName) WHERE Name = '\(Search)'", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            while (sqlite3_column_text(statement, i) != nil){
                guard let queryResultCol = sqlite3_column_text(statement, i) else {
                    print("Query result is nil")
                    return [[]]
                }
                var item = String(cString: queryResultCol)
                
                subarray.append(item)
                i = i + 1
            }
            i = 0
            rArray.append(subarray)
            subarray = []
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        return rArray
    }
    func getRowByID (tableName: String, id: Int) -> [[String]]{
        
        var rArray = [[String]]()
        var subarray = [String]()
        var i: Int32 = 0
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "select * from \(tableName) WHERE id = \(id)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            while (sqlite3_column_text(statement, i) != nil){
                guard let queryResultCol = sqlite3_column_text(statement, i) else {
                    print("Query result is nil")
                    return [[]]
                }
                var item = String(cString: queryResultCol)
                
                subarray.append(item)
                i = i + 1
            }
            i = 0
            rArray.append(subarray)
            subarray = []
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        return rArray
    }
    
}

