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
    
    let dbase: DataBaseHelper = DataBaseHelper()
    
    var categoryID: Int!
    var id: String!
    var array = [[Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Card details View is loaded")
        
        switch categoryID {
            
        case 0:
            array = dbase.getRowByID(tableName: "Event", id: Int(id)!)
            print("Event ID")
            
        case 1:
            array = dbase.getRowByID(tableName: "Sustainability", id: Int(id)!)
            print("Sus ID")
            
        case 2:
            array = dbase.getRowByID(tableName: "Club", id: Int(id)!)
            print("Club ID")
            
        case 3:
            array = dbase.getRowByID(tableName: "Club", id: Int(id)!)
            print("Club ID")
            
        default:
            print("default")
        }
        
        print( "Category id is \(categoryID!)")
        
        titleLabel.text = (array[0][1]) as? String
        descriptionLabel.text = (array[0][2]) as? String
        imgView.image = UIImage(named: (array[0][3] as? String)!)
        
    }
}
