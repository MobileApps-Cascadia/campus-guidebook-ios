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
    let clubDescriptions: [String] = ["test", "test", "test", "test"]
    
    let eventDescriptions: [String] = ["event", "event", "event", "event"]
    let sustainabilityDescriptions: [String] = ["sustainabaility", "sustainabaility", "sustainabaility", "sustainabaility"]
    
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

