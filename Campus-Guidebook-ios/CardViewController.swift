//
//  ViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 4/26/22.
//

import UIKit
import SwiftUI


class CellClass: UITableViewCell {
    
}

class CardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var cardTableView: UITableView!
    
    let dbase: DatabaseHelper = DatabaseHelper()
    let sampleData: SampleData = SampleData()
    
    @IBOutlet weak var filterBtn: UIButton!
    let transparentView = UIView()
    let dropDownTableView = UITableView()
    var selectedBtn = UIButton()
    var dataSource = [String]()
    
    var mClub: Club!
    var mEvent: Event!
    var mSustainability: Sustainability!
    
    var ClubsArray = [[Any]]()
    var EventsArray = [[Any]]()
    var SustainabilityArray = [[Any]]()
    
    var categoryID: Int!
    
    let searchController = UISearchController(searchResultsController: ResultsVC())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adds a search results updater
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        //RW
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        switch categoryID {
        case 0:
            self.title = "Events"
        case 1:
            self.title = "Sustainability"
        case 2:
            self.title = "Clubs"
        default:
            return self.title = "here"
        }
        searchController.searchBar.placeholder = "Search " + self.title!
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        

        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        cardTableView.delegate = self
        cardTableView.dataSource = self
        filterBtn.isHidden = true

        //remove tables and create them
        dbase.RemoveDBTables()
        dbase.CreateTable()
        
        //add sample data for clubs
        for i in 0..<sampleData.clubTitles.count {
            //make the new database row
            mClub = Club(name: sampleData.clubTitles[i], description: sampleData.clubDescriptions[i], imageURL: sampleData.clubPictures[i], startDate: sampleData.clubStartdates[i], startTime: sampleData.clubStartTimes[i], location: sampleData.clubLocations[i], contactURL: sampleData.clubContacts[i])
            dbase.addClubRow(Club: mClub) //add the database row to the table
        }
        
        //add sample data for events
        for i in 0..<sampleData.eventTitles.count {
            //make the new database row
            mEvent = Event(name: sampleData.eventTitles[i], description: sampleData.eventDescriptions[i], imageURL: sampleData.eventPictures[i], startDate: sampleData.eventStartDate[i], startTime: "", creationDate: "", location: sampleData.eventLocation[i])
            dbase.addEventRow(Event: mEvent) //add the database row to the table
        }
        
        //add sample data for sustainability
        for i in 0..<sampleData.sustainabilityTitles.count {
            //make the new database row
            mSustainability = Sustainability(name: sampleData.sustainabilityTitles[i], description: sampleData.sustainabilityDescriptions[i], imageURL: sampleData.sustainabilityPictures[i], location: "")
            dbase.addSustainabilityRow(Sustainability: mSustainability) //add the database row to the table
        }
        
        //checks which category has been tapped on
        switch categoryID {
        case 0:
            self.title = "Events"
            filterBtn.isHidden = false
            print("events")
        case 1:
            self.title = "Sustainability"
            print("sustainability")
        case 2:
            self.title = "clubs"
            filterBtn.isHidden = false
            print("Clubs")
        default:
            print("default")
        }
        
        ClubsArray = dbase.getAllTableContents(tablename: "Club")//get all rows
        EventsArray = dbase.getAllTableContents(tablename: "Event")//get all rows
        SustainabilityArray = dbase.getAllTableContents(tablename: "Sustainability")//get all rows
    }
    
    func addTransparentView(frame: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        dropDownTableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
        self.view.addSubview(dropDownTableView)
        dropDownTableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        dropDownTableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.transparentView.alpha = 0.5
            self.dropDownTableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height + 5, width: frame.width, height: CGFloat(self.dataSource.count * 45))
        }
    }
    
    @objc func removeTransparentView() {
        let frames = selectedBtn.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.transparentView.alpha = 0
            self.dropDownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)

        }
    }
    
    // MARK: How many rows in the tableView?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        if tableView == self.cardTableView {
            switch categoryID {
            case 0:
                self.title = "Events"
                count = sampleData.eventTitles.count
            case 1:
                self.title = "Sustainability"
                count = sampleData.sustainabilityTitles.count
            case 2:
                self.title = "Clubs"
                count = sampleData.clubTitles.count
            default:
                count = 0
            }

        }
        
        if tableView == self.dropDownTableView {
            count = dataSource.count
        }
        return count!
        
    }
    
    // MARK: Defines what cells are being used
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        if tableView == self.cardTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
            var image: UIImage!
            
            switch categoryID {
            case 0:
                //checks if img is a url
                image = getImg(urlString: EventsArray[indexPath.row][3] as! String)
                
                cell.configure(id: (EventsArray[indexPath.row][0] as? String)!,
                               title: (EventsArray[indexPath.row][1] as? String)!,
                               description: (EventsArray[indexPath.row][2] as? String)!,
                               picture: image,
                               date: EventsArray[indexPath.row][4] as? String,
                               location: EventsArray[indexPath.row][7] as? String)
            case 1:
                //checks if img is a url
                image = getImg(urlString: SustainabilityArray[indexPath.row][3] as! String)
                
                cell.configure(id: (SustainabilityArray[indexPath.row][0] as? String)!,
                               title: (SustainabilityArray[indexPath.row][1] as? String)!,
                               description: (SustainabilityArray[indexPath.row][2] as? String)!,
                               picture: image)
            case 2:
                //checks if img is a url
                image = getImg(urlString: ClubsArray[indexPath.row][3] as! String)
                
                cell.configure(id: (ClubsArray[indexPath.row][0] as? String)!,
                               title: (ClubsArray[indexPath.row][1] as? String)!,
                               description: (ClubsArray[indexPath.row][2] as? String)!,
                               picture: image)
            default:
                print("default")
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = dataSource[indexPath.row]
            return cell
        }
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.cardTableView {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "CardDetailsView") as? CardDetailViewController
                
            {
                vc.categoryID = categoryID
                
                switch categoryID {
                case 0:
                    vc.id = EventsArray[indexPath.row][0] as? String
                    print("id Event")
                    
                case 1:
                    vc.id = SustainabilityArray[indexPath.row][0] as? String
                    print("id Sus")
                    
                case 2:
                    vc.id = ClubsArray[indexPath.row][0] as? String
                    print("id Club")
                default:
                    print("default")
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if tableView == self.dropDownTableView {
            selectedBtn.setTitle(dataSource[indexPath.row], for: .normal)
            let df = DateFormatter()
            df.dateFormat = "MM-dd-yyyy"
            
            // filter by most recent
            if dataSource[indexPath.row] == "Most Recent" {
                switch categoryID {
                case 0:
                    EventsArray = EventsArray.sorted(by: {
                        ("\(df.date(from: String(describing: $0[4] as! String) )! as Any)") < ("\(df.date(from: String(describing: $1[4] as! String) )! as Any)")
                    })
//                case 2:
//                    ClubsArray = ClubsArray.sorted(by: {
//                        ("\(df.date(from: String(describing: $0[4] as! String) )! as Any)") < ("\(df.date(from: String(describing: $1[4] as! String) )! as Any)")
//                    })
                default:
                    print("default")
                }
            }
            // filter by less recent
            else {
                switch categoryID {
                case 0:
                    EventsArray = EventsArray.sorted(by: {
                        ("\(df.date(from: String(describing: $0[4] as! String) )! as Any)") > ("\(df.date(from: String(describing: $1[4] as! String) )! as Any)")
                    })
                    cardTableView.reloadData()
//                case 2:
//                    ClubsArray = ClubsArray.sorted(by: {
//                        ("\(df.date(from: String(describing: $0[4] as! String) )! as Any)") > ("\(df.date(from: String(describing: $1[4] as! String) )! as Any)")
//                    })
                default:
                    print("default")
                }
            }
            cardTableView.reloadData()
            removeTransparentView()
        }
        
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
    

    
    // MARK: Search result updater
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        let vc = searchController.searchResultsController as? ResultsVC
        vc?.view.backgroundColor = .white
        print(text)
    }
    

    @IBAction func filterBtn_Onclick(_ sender: Any) {
        dataSource = ["Most Recent", "Less Recent"]
        selectedBtn = filterBtn
        addTransparentView(frame: filterBtn.frame)
    }

}

class ResultsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
        

extension UIImage {
    
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        
        self.init(data: imageData)
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
