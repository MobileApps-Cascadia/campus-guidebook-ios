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
    
//    var selectedImage: Int?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let imageToLoad = selectedImage {
//            imgView.image = UIImage(named: imageToLoad)
//        }
        
        
        var data: DataBaseHelper = DataBaseHelper()
        var testClub: Club = Club(name: "Sample Club Name", description: "Sample Club Description")
        
        data.addClubRow(Club: testClub)
        data.addClubRow(Club: testClub)
        data.addClubRow(Club: testClub)

        imgView.image = UIImage(named: "clubs_logo-1")!
        titleLabel.text = testClub.Name
        descriptionLabel.text = testClub.Description
        
    }
    

    
    
}
