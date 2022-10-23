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
  
    let dbTest: DataBaseTests = DataBaseTests()
    
    let mainNavigationCardNames = ["Events", "Sustainability", "Student Clubs", "Arc", "Library", "Kodiac Corner", "Food Trucks", "Campus Map", ]
    
    let mainNavigationCardImages = [UIImage(named: "calendar-icon"), UIImage(named: "sustainability_practices_logo"), UIImage(named: "clubs_logo"), UIImage(named: "college_students"), UIImage(named: "library"), UIImage(named: "cascadia_mascot"), UIImage(named: "food_truck"), UIImage(named: "cascadia_walkway")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //do tests of db
        dbTest.removeTables()
        dbTest.makeTables()
        dbTest.makeTests()
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
        
        
        switch indexPath.row {
        case 0:
            self.title = "events"
            print("events")
        case 1:
            self.title = "sustainability"
            print("sustainability")
        case 2:
            self.title = "clubs"
            print("clubs")
        default:
            print("default")
        }
        
        if indexPath.row == 7 {
            let vc1 = storyboard?.instantiateViewController(withIdentifier: "mapViewController") as? mapViewController
            self.navigationController?.pushViewController(vc1!, animated: true)
        }
        if indexPath.row < 3 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardsViewController") as? CardsViewController
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

