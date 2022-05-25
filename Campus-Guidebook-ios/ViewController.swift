//
//  ViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 4/26/22.
//

import UIKit
import SQLite3
import Foundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    //______________________________//
    let dbase: DataBaseHelper = DataBaseHelper()
    
    //______________________________//
    
    let mainNavigationCardNames = ["Events", "Sustainability", "Student Clubs", "Arc", "Library", "Kodiac Corner", "Food Trucks", "Campus Map", ]
    
    let mainNavigationCardImages = [UIImage(named: "calendar-icon"), UIImage(named: "sustainability_practices_logo"), UIImage(named: "clubs_logo"), UIImage(named: "college_students"), UIImage(named: "library"), UIImage(named: "cascadia_mascot"), UIImage(named: "food_truck"), UIImage(named: "cascadia_walkway")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //__________Club_Tests___________//
        print("\n\n\nThis is the start of the Club demo tests.")
        var mClub: Club = Club(name: "Club TestName", description: "Test description") //make the new database row
        var array = [[Any]]()
        dbase.addClubRow(Club: mClub) //add the database row to the table
        dbase.addClubRow(Club: mClub) //add the database row to the table
        dbase.addClubRow(Club: mClub) //add the database row to the table
        
        array = dbase.getAllTableContents(tablename: "Club")//get all rows
        for item in array{
            print(item)
        }
        
        dbase.removeRowByID(tableName: "Club", id: 2)//remove a row with the id of 2
        
        array = dbase.getAllTableContents(tablename: "Club")//get all rows. the row with the id of 2 should be missing
        print(array)
        
        var array2 = dbase.getRow(tableName: "Club", Search: "Club TestName")//search for an entry by string
        print("\n")
        print(array2)
        
        
        
//        //__________Event_Tests___________//
        print("\n\n\nThis is the start of the Event demo tests.")
        var mEvent: Event = Event(name: "Event TestName", description: "Test description") //make the new database row
        
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
        var mSustainability: Sustainability = Sustainability(name: "Sustainability TestName", description: "Test description", image: "Cats. All the cats.") //make the new database row
                
                dbase.addSustainabilityRow(Sustainability: mSustainability) //add the database row to the table
                dbase.addSustainabilityRow(Sustainability: mSustainability) //add the database row to the table
                dbase.addSustainabilityRow(Sustainability: mSustainability) //add the database row to the table
                
                array = dbase.getAllTableContents(tablename: "Sustainability")//get all rows
        print(array[0])
        print(array[0][0])
                for item in array{
                    print(item[0])
                }
                
                dbase.removeRowByID(tableName: "Sustainability", id: 2)//remove a row with the id of 2
                
                array = dbase.getAllTableContents(tablename: "Sustainability")//get all rows. the row with the id of 2 should be missing
                print(array)
                
                
        array2 = dbase.getRow(tableName: "Sustainability", Search: "Sustainability TestName")//search for an entry by string
        print("\n")
        print(array2)
                

//        //__________End_of_my_tests___________//
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainNavigationCardNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.mainNavigationCardLabel.text = mainNavigationCardNames[indexPath.row]
        cell.mainNavigationCardImage.image = mainNavigationCardImages[indexPath.row]
        
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 6.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
      didSelectItemAt indexPath: IndexPath) {
        print("Cell \(mainNavigationCardNames[indexPath.row]) - \(indexPath.row) clicked")
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardsViewController") as? CardsViewController
        
        if indexPath.row < 3 {
            vc?.categoryID = indexPath.row
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
            vc?.mainNavigationCardName = mainNavigationCardNames[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        
      }


}

