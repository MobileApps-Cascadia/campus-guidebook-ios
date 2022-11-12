//
//  CardDetailViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 5/24/22.
//

import UIKit

class CardDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    // Add date, time, location, and contactUrl properties for IBoutlet here
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    
    let dbase: DatabaseHelper = DatabaseHelper()
    
    var categoryID: Int!
    var id: String!
    var array = [[Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Card details View is loaded")
        
        switch categoryID {
        case 0:
            array = dbase.getRowByID(tableName: "Event", id: Int(id)!)
            startDateLabel.text = "Date: \(((array[0][4]) as? String)!)"
            startTimeLabel.text = "Time: \(((array[0][5]) as? String)!)"
            contactInfoLabel.text = "Contact: \(((array[0][6]) as? String)!)"
            locationLabel.text = "Location: \(((array[0][7]) as? String)!)"
            print("Event ID")
        case 1:
            array = dbase.getRowByID(tableName: "Sustainability", id: Int(id)!)
            startDateLabel.text = ""
            startTimeLabel.text = ""
            contactInfoLabel.text = ""
            locationLabel.text = ""
            print("Sus ID")
        case 2:
            array = dbase.getRowByID(tableName: "Club", id: Int(id)!)
            startDateLabel.text = "Date: \(((array[0][4]) as? String)!)"
            startTimeLabel.text = "Time: \(((array[0][5]) as? String)!)"
            contactInfoLabel.text = "Contact: \(((array[0][6]) as? String)!)"
            locationLabel.text = "Location: \(((array[0][7]) as? String)!)"
            print("Club ID")
        default:
            print("default")
        }
        
        print( "Category id is \(categoryID!)")
        
        print(array)
        titleLabel.text = (array[0][1]) as? String
        descriptionLabel.text = "Description: \n\(((array[0][2]) as? String)!)"
        let image = getImg(urlString: array[0][3] as! String)
        imgView.image = image

        

        
//        dateLabel.text = (array[0][4]) as? String
//        locationLabel.text = (array[0][7]) as? String
        
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

//extension UIImage {
//
//    convenience init?(withContentsOfUrl url: URL) throws {
//        let imageData = try Data(contentsOf: url)
//
//        self.init(data: imageData)
//    }
//}
