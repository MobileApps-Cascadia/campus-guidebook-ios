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
        let conn: OpaquePointer = dbase.GetOpenDB()
        //__________Club_Tests___________//
        print("This is the start of the Club demo tests.")
        var mClub: Club = Club(name: "Club TestName", description: "Test description")
        // Do any additional setup after loading the view.
        mClub.addRow(db: conn) //after you made a new club object, you can call its addrow method and it will add itself to the database
        mClub.addRow(db: conn)
        mClub.addRow(db: conn)
        mClub.addRow(db: conn)
        var array = mClub.getRow(db: conn, Search: "Club TestName") // getrow will return an array in the order of name, description, tbc
        mClub.removeRowByID(db: conn, id: 2) // this should delete the row with an id of 2
        print("Club name in VC = \(array[0])\n")
        
        //__________Event_Tests___________//
        print("This is the start of the Event demo tests.")
        var mEvent: Event = Event(name: "Event TestName", description: "Test description")
        // Do any additional setup after loading the view.
        mEvent.addRow(db: conn) //after you made a new club object, you can call its addrow method and it will add itself to the database
        mEvent.addRow(db: conn)
        mEvent.addRow(db: conn)
        mEvent.addRow(db: conn)
        array = mEvent.getRow(db: conn, Search: "Event TestName") // getrow will return an array in the order of name, description, tbc
        mEvent.removeRowByID(db: conn, id: 2) // this should delete the row with an id of 2
        print("Event name in VC = \(array[0])\n")
        
        //__________Sustainability_Tests___________//
        print("This is the start of the Sustainability demo tests.")
        var mSustainability: Sustainability = Sustainability(name: "Sustainability TestName", description: "Thest description")
        // Do any additional setup after loading the view.
        mSustainability.addRow(db: conn) //after you made a new club object, you can call its addrow method and it will add itself to the database
        mSustainability.addRow(db: conn)
        mSustainability.addRow(db: conn)
        mSustainability.addRow(db: conn)
        array = mSustainability.getRow(db: conn, Search: "Sustainability TestName") // getrow will return an array in the order of name, description, tbc
        mEvent.removeRowByID(db: conn, id: 2) // this should delete the row with an id of 2
        print("Sustainability name in VC = \(array[0])\n")
        //__________End_of_my_tests___________//
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

