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
        getImg(urlString: array[0][3] as! String) { image in
            self.imgView.image = image
        }
    }
    
    func getImg(urlString: String, completion: @escaping (UIImage) -> Void) {
        let imageUrlString = urlString != "" ? urlString : "cascadia_mascot"
        if (imageUrlString.isValidURL) {
            let imageUrl = URL(string: imageUrlString)
            fetchAsyncImage(url: imageUrl!) { image in
                // Return the image when it is ready
                completion(image)
            }
        } else {
            let image = UIImage(named: imageUrlString)!
            completion(image)
        }
    }

    func fetchAsyncImage(url: URL, completion: @escaping (UIImage) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // do something with the data here
                if let image = UIImage(data: data) {
                    completion(image)
                }
            } else if let error = error {
                // handle the error here
                print("error fetching image error: \(error)")
            }
        }

        task.resume()
    }

}


