//
//  ViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 4/26/22.
//

import UIKit

class CardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cardTableView: UITableView!

    var categoryID: Int!
    let clubPictures: [UIImage] =
    [UIImage(named: "clubs_logo-1")!,
     UIImage(named: "dnd_club_logo")!,
     UIImage(named: "engineers_club")!,
     UIImage(named: "japanese_culture_club")!]
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
   
    }
    
    // MARK: How many rows in the tableView?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubPictures.count
    }
    
    // MARK: Defines what cells are being used
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        
        switch categoryID {
        case 0:
            cell.configure(picture: clubPictures[indexPath.row], title: clubTitles[indexPath.row], description: eventDescriptions[indexPath.row])
            print("events")
        case 1:
            cell.configure(picture: clubPictures[indexPath.row], title: clubTitles[indexPath.row], description: sustainabilityDescriptions[indexPath.row])
            print("sustainability")
        case 2:
            cell.configure(picture: clubPictures[indexPath.row], title: clubTitles[indexPath.row], description: clubDescriptions[indexPath.row])
            print("clubs")
        default:
            print("default")
        }
        
        
        return cell
    }

}

