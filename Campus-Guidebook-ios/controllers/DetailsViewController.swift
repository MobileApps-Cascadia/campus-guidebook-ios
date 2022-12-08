//
//  DetailsViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 4/27/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var mainNavigationCardName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = mainNavigationCardName
        // Do any additional setup after loading the view.
    }

}
