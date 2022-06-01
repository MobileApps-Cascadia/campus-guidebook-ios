//
//  ViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 4/26/22.
//

import UIKit
import SwiftUI

class CardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cardTableView: UITableView!
    
    let dbase: DatabaseHelper = DatabaseHelper()
    let sampleData: SampleData = SampleData()
    
    var mClub: Club!
    var mEvent: Event!
    var mSustainability: Sustainability!
    
    var ClubsArray = [[Any]]()
    var EventsArray = [[Any]]()
    var SustainabilityArray = [[Any]]()
    
    var categoryID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove tables and create them
        dbase.RemoveDBTables()
        dbase.CreateTable()
        
        //add sample data for clubs
        for i in 0..<sampleData.clubTitles.count {
            //make the new database row
            mClub = Club(name: sampleData.clubTitles[i], description: sampleData.clubDescriptions[i], imageURL: sampleData.clubPictures[i])
            dbase.addClubRow(Club: mClub) //add the database row to the table
        }
        
        //add sample data for events
        for i in 0..<sampleData.eventTitles.count {
            //make the new database row
            mEvent = Event(name: sampleData.eventTitles[i], description: sampleData.eventDescriptions[i], imageURL: sampleData.eventPictures[i], startDate: "", startTime: "", creationDate: "", location: "")
            dbase.addEventRow(Event: mEvent) //add the database row to the table
        }
        
        //add sample data for sustainability
        for i in 0..<sampleData.sustainabilityTitles.count {
            //make the new database row
            mSustainability = Sustainability(name: sampleData.sustainabilityTitles[i], description: sampleData.sustainabilityDescriptions[i], imageURL: sampleData.sustainabilityPictures[i], location: "")
            dbase.addSustainabilityRow(Sustainability: mSustainability) //add the database row to the table
        }
        
        switch categoryID {
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
        
        ClubsArray = dbase.getAllTableContents(tablename: "Club")//get all rows
        EventsArray = dbase.getAllTableContents(tablename: "Event")//get all rows
        SustainabilityArray = dbase.getAllTableContents(tablename: "Sustainability")//get all rows
    }
    
    // MARK: How many rows in the tableView?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categoryID {
        case 0:
            self.title = "events"
            return sampleData.eventTitles.count
        case 1:
            self.title = "sustainability"
            return sampleData.sustainabilityTitles.count
        case 2:
            self.title = "clubs"
            return sampleData.clubTitles.count
        default:
            return 0
        }
        
    }
    
    // MARK: Defines what cells are being used
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        var image: UIImage!
        
        switch categoryID {
        case 0:
            //checks if img is a url
            image = getImg(urlString: EventsArray[indexPath.row][3] as! String)
            
            cell.configure(id: (EventsArray[indexPath.row][0] as? String)!,
                           title: (EventsArray[indexPath.row][1] as? String)!,
                           description: (EventsArray[indexPath.row][2] as? String)!,
                           picture: image)
        case 1:
            //checks if img is a url
            image = getImg(urlString: SustainabilityArray[indexPath.row][3] as! String)
            
            cell.configure(id: (SustainabilityArray[indexPath.row][0] as? String)!,
                           title: (SustainabilityArray[indexPath.row][1] as? String)!,
                           description: (SustainabilityArray[indexPath.row][2] as? String)!,
                           picture: image)
        case 2:
            //checks if img is a url
            image = getImg(urlString: ClubsArray[indexPath.row][3] as! String)
            
            cell.configure(id: (ClubsArray[indexPath.row][0] as? String)!,
                           title: (ClubsArray[indexPath.row][1] as? String)!,
                           description: (ClubsArray[indexPath.row][2] as? String)!,
                           picture: image)
        default:
            print("default")
        }
        return cell
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CardDetailsView") as? CardDetailViewController
            
        {
            vc.categoryID = categoryID
            
            switch categoryID {
            case 0:
                vc.id = EventsArray[indexPath.row][0] as? String
                print("id Event")
                
            case 1:
                vc.id = SustainabilityArray[indexPath.row][0] as? String
                print("id Sus")
                
            case 2:
                vc.id = ClubsArray[indexPath.row][0] as? String
                print("id Club")
            default:
                print("default")
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getImg(urlString: String) -> UIImage {
        let imageUrlString = urlString != "" ? urlString : "cascadia_mascot"
        if (imageUrlString.isValidURL) {
            let imageUrl = URL(string: imageUrlString)
            return try! UIImage(withContentsOfUrl: imageUrl!)!
        }
        else {
            return UIImage(named: imageUrlString)!
        }
    }
    
}

extension UIImage {
    
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        
        self.init(data: imageData)
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
