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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
