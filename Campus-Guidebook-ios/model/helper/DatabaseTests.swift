//
//  DatabaseTests.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 5/24/22.
//

import Foundation

class DataBaseTests {
    let dbase: DataBaseHelper = DataBaseHelper()

    func makeTables() {
        dbase.CreateTable()
    }
    
    func makeTests () {
        //__________Club_Tests___________//
        print("\n\n\nThis is the start of the Club demo tests.")
        let mClub: Club = Club(name: "Club TestName", description: "Test description", imageURL: "Cats. All the cats.") //make the new database row
        var array = [[Any]]()
        dbase.addClubRow(Club: mClub) //add the database row to the table
        dbase.addClubRow(Club: mClub) //add the database row to the table
        dbase.addClubRow(Club: mClub) //add the database row to the table
        
        array = dbase.getAllTableContents(tablename: "Club")//get all rows
        print("//////////////")
        print(array)
        print("//////////////")
        for item in array{
            print(item)
        }
        print("//////////////")
        dbase.removeRowByID(tableName: "Club", id: 2)//remove a row with the id of 2
        
        array = dbase.getAllTableContents(tablename: "Club")//get all rows. the row with the id of 2 should be missing
        print(array)
        
        var array2 = dbase.getRow(tableName: "Club", Search: "Club TestName")//search for an entry by string
        print("\n")
        print(array2)
        
        
        
//        //__________Event_Tests___________//
        print("\n\n\nThis is the start of the Event demo tests.")
        var mEvent: Event = Event(name: "Event TestName", description: "Test description", imageURL: "Cats. All the cats.", startDate: "startDate", startTime: "startTime", creationDate: "creationDate", location: "location") //make the new database row
        
        dbase.addEventRow(Event: mEvent) //add the database row to the table
        dbase.addEventRow(Event: mEvent) //add the database row to the table
        dbase.addEventRow(Event: mEvent) //add the database row to the table
        
        array = dbase.getAllTableContents(tablename: "Event")//get all rows
        for item in array{
            print(item)
        }
        
        dbase.removeRowByID(tableName: "Event", id: 2)//remove a row with the id of 2
        
        array = dbase.getAllTableContents(tablename: "Event")//get all rows. the row with the id of 2 should be missing
        print(array)
        

        array2 = dbase.getRow(tableName: "Event", Search: "Event TestName")//search for an entry by string
        print("\n")
        print(array2)
        

//        //__________Sustainability_Tests___________//
        print("\n\n\nThis is the start of the Sustainability demo tests.")
        let mSustainability: Sustainability = Sustainability(name: "Sustainability TestName", description: "Test description", imageURL: "Cats. All the cats.", location: "location") //make the new database row
                
                dbase.addSustainabilityRow(Sustainability: mSustainability) //add the database row to the table
                dbase.addSustainabilityRow(Sustainability: mSustainability) //add the database row to the table
                dbase.addSustainabilityRow(Sustainability: mSustainability) //add the database row to the table
                
                array = dbase.getAllTableContents(tablename: "Sustainability")//get all rows
                for item in array{
                    print(item)
                }
                
                dbase.removeRowByID(tableName: "Sustainability", id: 2)//remove a row with the id of 2
                
                array = dbase.getAllTableContents(tablename: "Sustainability")//get all rows. the row with the id of 2 should be missing
                print(array)
                
                
        array2 = dbase.getRow(tableName: "Sustainability", Search: "Sustainability TestName")//search for an entry by string
        print("\n")
        print(array2)
                

//        //__________End_of_my_tests___________//
    }
    
    func removeTables() {
        dbase.RemoveDBTables()
    }
}
