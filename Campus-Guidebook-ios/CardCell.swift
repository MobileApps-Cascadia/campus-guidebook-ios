//
//  CardCell.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 4/30/22.
//

import UIKit

class CardCell: UITableViewCell {
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var id: String!
    
    
    // MARK: Set up the cell
    func configure(id: String, title: String, description: String, picture: UIImage, date: String? = nil, location: String? = nil)
    {
        
        DispatchQueue.main.async {
            self.id = id
            self.pictureView.image = picture
            self.titleLabel.text = title
            self.descriptionLabel.text = description
            
            if let d = date {
                self.dateTimeLabel.text = "Date: \(d)"
            }
            if let l = location {
                self.locationLabel.text = "Location: \(l)"
            }
            
            self.cardView.layer.shadowColor = UIColor.gray.cgColor
            self.cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            self.cardView.layer.shadowOpacity = 1.0
            self.cardView.layer.masksToBounds = false
            self.cardView.layer.cornerRadius = 2.0
        }
    }
}
