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
    
    var array = [[Any]]()
    
    var categoryID: Int!
    var id: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch categoryID {
            
        case 0:
            array = dbase.getRowByID(tablename: "Events", id)
        case 1:
            array = dbase.getRowByID(tablename: "Sustainability", id)
        case 2:
            array = dbase.getRowByID(tablename: "Clubs", id)
        default:
            print("default")
        }
        
        imgView.image = UIImage(named: ((array[3]) as? String)!)!
        titleLabel.text = array[1] as? String
        descriptionLabel.text = array[2] as? String
        
    }
}
