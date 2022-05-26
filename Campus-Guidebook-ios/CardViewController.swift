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
    
    let dbase: DataBaseHelper = DataBaseHelper()
    let sampleData: SampleData = SampleData()
    
    var mClub: Club!
    var mEvent: Event!
    var mSustainability: Sustainability!

    var ClubsArray = [[Any]]()
    var EventsArray = [[Any]]()
    var SustainabilityArray = [[Any]]()
    
    var categoryID: Int!
    let clubPictures: [String] =
    ["clubs_logo-1",
     "dnd_club_logo",
     "engineers_club",
     "japanese_culture_club"]
    let clubTitles: [String] = ["Clubs at Cascadia", "DnD Club", "Engineers Club", "Japanese Culture Club"]
    let clubDescriptions: [String] = ["club", "club", "club", "club"]
    
    let eventDescriptions: [String] = ["event", "event", "event", "event"]
    let sustainabilityDescriptions: [String] = ["sustainabaility", "sustainabaility", "sustainabaility", "sustainabaility"]
    
    let titles: [String] = ["Clubs at Cascadia", "DnD Club", "Engineers Club", "Japanese Culture Club"]
    let descriptions: [String] = [
        "Roll the dice at EAB and CEB's annual Casino Night!",
        "Roll20 until you reach the lands of 5e",
        "The engineering club is open to any student who is interested in science, technology, engineering, and math (STEM). Through hands on activities, members of all skill levels will have the opportunity to design, build, and share engineered projects with other creative problem solvers. Get ready to strengthen your skills, create a collection of projects related to your career, and connect with your peers! Some of the club projects we've undertaken include designing 3d printing models, making a video game with python, and electronic prototyping with Arduino.",
        "The purpose of this club is to provide a comfortable place for the students at Cascadia college to learn and experience Japanese culture together. In our club, we will share traditional Japanese culture such as Japanese calligraphy, origami, karate, etc. together."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove tables and create them
        dbase.RemoveDBTables()
        dbase.CreateTable()
        
        //add sample data for clubs
        for i in 0..<sampleData.clubTitles.count {
            //make the new database row
            mClub = Club(name: sampleData.clubTitles[i], description: sampleData.clubDescriptions[i], image: sampleData.clubPictures[i])
            dbase.addClubRow(Club: mClub) //add the database row to the table
        }
        
        //add sample data for events
        for i in 0..<sampleData.eventTitles.count {
            //make the new database row
            mEvent = Event(name: sampleData.eventTitles[i], description: sampleData.eventDescriptions[i], image: sampleData.eventPictures[i])
            dbase.addEventRow(Event: mEvent) //add the database row to the table
        }
        
        //add sample data for sustainability
        for i in 0..<sampleData.sustainabilityTitles.count {
            //make the new database row
            mSustainability = Sustainability(name: sampleData.sustainabilityTitles[i], description: sampleData.sustainabilityDescriptions[i], image: sampleData.sustainabilityPictures[i])
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
        
        switch categoryID {
        case 0:
            cell.configure(id: (EventsArray[indexPath.row][0] as? String)!,
                           title: (EventsArray[indexPath.row][1] as? String)!,
                           description: (EventsArray[indexPath.row][2] as? String)!,
                           picture: UIImage(named: (EventsArray[indexPath.row][3] as? String)!)!)
            print("events")
        case 1:
            cell.configure(id: (SustainabilityArray[indexPath.row][0] as? String)!,
                           title: (SustainabilityArray[indexPath.row][1] as? String)!,
                           description: (SustainabilityArray[indexPath.row][2] as? String)!,
                           picture: UIImage(named: (SustainabilityArray[indexPath.row][3] as? String)!)!)
            print("sustainability")
        case 2:
            cell.configure(id: (ClubsArray[indexPath.row][0] as? String)!,
                           title: (ClubsArray[indexPath.row][1] as? String)!,
                           description: (ClubsArray[indexPath.row][2] as? String)!,
                           picture: UIImage(named: (ClubsArray[indexPath.row][3] as? String)!)!)
            print("clubs")
        default:
            print("default")
        }
        return cell
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CardDetailsView") as? CardDetailViewController {
            vc.categoryID = categoryID
            
            switch categoryID {
            case 0:
                vc.id = EventsArray[indexPath.row][0] as! String

            case 1:
                vc.id = SustainabilityArray[indexPath.row][0] as! String

            case 2:
                vc.id = ClubsArray[indexPath.row][0] as! String

            default:
                print("default")
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // This function is called before the segue
         func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            // Get a reference to the second view controller
            let secondViewController = segue.destination as! CardDetailViewController

            // Set a variable in the second view controller with the String to pass
            secondViewController.receivedString = EventsArray[indexPath.row][0] as! String
        }

    }
    
    
}

