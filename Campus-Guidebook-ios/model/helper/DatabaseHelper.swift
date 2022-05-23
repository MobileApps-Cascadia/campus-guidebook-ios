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
    var ClubDB: OpaquePointer?
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
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
        let CreateClubTable: String = "CREATE TABLE IF NOT EXISTS Club (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT);" //create the Clubs table
        let CreateEventsTable: String = "CREATE TABLE IF NOT EXISTS Event (id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Description TEXT, Time TEXT, Date TEXT);" //create the Event table
        let CreateSustainabilityTable: String = "CREATE TABLE IF NOT EXISTS Sustainability (id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Description TEXT);" //create the Sustainability table
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
    func RemoveDBTables(){
        var ClubsTable: String = "DROP TABLE IF EXISTS Club;"
        var EventsTable: String = "DROP TABLE IF EXISTS Event;"
        var SustainabilityTable: String = "DROP TABLE IF EXISTS Sustainability;"
        
        initTable(table: ClubsTable, name: "Club")
        initTable(table: EventsTable, name: "Event")
        initTable(table: SustainabilityTable, name: "Sustainability")
    }
    private func RemoveDB(table: String, name: String){
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, table, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("\(name) table has been deleted successfuly")
                
            }else{
                print("\(name) table delete fail")
            }
        }else{
            print("\(name) table delete prep fail \(SQLITE_ERROR)")
        }
        
    }
    func getAllTableContents(tablename: String) -> Array<Any>{
        var Array: [Any] = []
        var subarray: [Any] = []
        var i: Int32 = 0

            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, "select * from \(tablename)", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }

            while sqlite3_step(statement) == SQLITE_ROW {
            
                //while (sqlite3_column_text(statement, i) != nil){
                    
                guard let queryResultCol = sqlite3_column_text(statement, 0) else {
                    print("Query result is nil")
                    return Array
                }
                var item = String(cString: queryResultCol)
                subarray.append(item)
                guard let queryResultCol = sqlite3_column_text(statement, 1) else {
                    print("Query result is nil")
                    return Array
                }
                 item = String(cString: queryResultCol)
                subarray.append(item)
                guard let queryResultCol = sqlite3_column_text(statement, 2) else {
                    print("Query result is nil")
                    return Array
                }
                item = String(cString: queryResultCol)
               subarray.append(item)
                
                  //  i = i + 1
                //}
                i = 0
                Array.append(subarray)
                subarray = []
            }

            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
        
            statement = nil
            return Array
        }
    
    
    func GetOpenDB() -> OpaquePointer{ //this method will return the activated database connection to use in objects
        return db!
        
    }
    
    
    
    
    func addClubRow(Club: Club?){
        var statement: OpaquePointer?
        var i: Int = 0
        var valueString: String = ""
        
        
        if (Club != nil){
            let mClub: Club = Club!
            let columnArray = [mClub.Name, mClub.Description] //add new values here when you add another column to the table.
            while (i < mClub.InsertableValueCount){ //autobuilding the string of values based on the number of potental values in the spicific table
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
    
    
    
    
    func addRow(Club: Club?, Event: Event?, Sustainability: Sustainability?){ //this will need some thinking
        var statement: OpaquePointer?
        var i: Int = 0
        var valueString: String = ""
        
        
        if (Sustainability != nil){
            while (i < Club!.InsertableValueCount){ //autobuilding the string of values based on the number of potental values in the spicific table
                if (i == 1){
                    valueString = "?"
                }
                else{
                    valueString = valueString + ", ?"
                }
                i = i + 1
            }
            i = 0
            if sqlite3_prepare_v2(db, "insert into \(Club!.TableName) (\(Club!.TableColumns)) values (\(valueString))", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            while (i < Club!.InsertableValueCount){ // walk through the table and bind a select number of text items to the fields
                if sqlite3_bind_text(statement, Int32(i)+1, Club!.TableName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding foo: \(errmsg)")
                }
                i = i + 1
            }
            i = 0
        }
        if (Event != nil){
            
            while (i < Event!.InsertableValueCount){ //autobuilding the string of values based on the number of potental values in the spicific table
                if (i == 1){
                    valueString = "?"
                }
                else{
                    valueString = valueString + ", ?"
                }
                i = i + 1
            }
            i = 0
            if sqlite3_prepare_v2(db, "insert into \(Event!.TableName) (\(Event!.TableColumns)) values (\(valueString))", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            while (i < Event!.InsertableValueCount){
                if sqlite3_bind_text(statement, Int32(i)+1, Event!.TableName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding foo: \(errmsg)")
                }
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
    func getRow (tableName: String, Search: String) -> Array<Any>{
        
        var Array: [Any] = []
        var SubArray: [Any] = []
            
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, "select id, name, description from \(tableName) where name = '\(Search)'", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                print("id = \(id); ", terminator: "")

                if let cString = sqlite3_column_text(statement, 1) {
                    let name = String(cString: cString)
                    print("name = \(name)")
                    if let cString = sqlite3_column_text(statement, 2) {
                        let description = String(cString: cString)
                        print("description = \(description)")
                        
                        SubArray.append(id)
                        SubArray.append(name)
                        SubArray.append(description)
                        Array.append(SubArray)
                        SubArray = []
                    } else {
                        print("description not found")
                    }

                } else {
                    print("name not found")
                }
            }

            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
        
            statement = nil
            return Array
        }

}

