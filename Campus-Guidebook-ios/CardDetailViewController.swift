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
    
    var selectedImage: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let imageToLoad = selectedImage {
//            imgView.image = UIImage(named: imageToLoad)
//        }
        imgView.image = UIImage(named: "dnd_club_logo")!
        titleLabel.text = "hi"
        descriptionLabel.text = "description"
    }
    
    func configure(picture: UIImage, title: String, description: String) {
        imgView.image = UIImage(named: "dnd_club_logo")!
        titleLabel.text = "hi"
        descriptionLabel.text = "description"
    }
    
    
}
