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
        self.id = id
        pictureView.image = picture
        titleLabel.text = title
        descriptionLabel.text = description
        dateTimeLabel.text = "Date: \(date!)"
        locationLabel.text = "Location: \(location!)"
        
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 2.0
    }
}
