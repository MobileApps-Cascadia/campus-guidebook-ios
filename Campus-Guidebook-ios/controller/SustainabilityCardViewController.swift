//
//  SustainabilityCardViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Haytham Odeh on 12/9/22.
//

import Foundation
import UIKit

class SustainabilityCardViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //    @IBOutlet weak var locationNavButton: UIButton!
    
    let dbase: DatabaseHelper = DatabaseHelper()
    var id: String!
    var array = [[Any]]()
    var LocationButtonText: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array = dbase.getRowByID(tableName: "Sustainability", id: Int(id)!)
        
        titleLabel.text = (array[0][1]) as? String
        descriptionLabel.text = "Description: \n\(((array[0][2]) as? String)!)"
        let image = getImg(urlString: array[0][3] as! String)
        imgView.image = image
        
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
