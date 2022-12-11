//
//  ViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 4/26/22.
//
import UIKit
import SwiftUI
import Longinus


class CellClass: UITableViewCell {
    
}

class CardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredObjects = [[Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        cardTableView.delegate = self
        cardTableView.dataSource = self
        filterBtn.isHidden = true
        
        // Create DB tables if they don't exist
        dbase.CreateTable()
        
        // Add sample data for Clubs
        if (dbase.getAllTableContents(tablename: "Club").count != 0){
            print("Data already added to Club")
        } else{
            print("Adding data already added to Club")
            for i in 0..<sampleData.clubTitles.count {
                //make the new database row
                mClub = Club(name: sampleData.clubTitles[i], description: sampleData.clubDescriptions[i], imageURL: sampleData.clubPictures[i], startDate: sampleData.clubStartdates[i], startTime: sampleData.clubStartTimes[i], creationDate: "", location: sampleData.clubLocations[i], contactURL: sampleData.clubContacts[i])
                dbase.addClubRow(Club: mClub) //add the database row to the table
            }
        }
        
        // Add sample data for Events
        if (dbase.getAllTableContents(tablename: "Event").count != 0){
            print("Data already added to Event")
        } else{
            print("Adding data already added to Event")
            for i in 0..<sampleData.eventTitles.count {
                //make the new database row
                mEvent = Event(name: sampleData.eventTitles[i], description: sampleData.eventDescriptions[i], imageURL: sampleData.eventPictures[i], startDate: sampleData.eventStartDate[i], startTime: sampleData.eventStartTimes[i], creationDate: "", location: sampleData.eventLocation[i], contactURL: sampleData.eventContacts[i], subscriptionsCounter: sampleData.eventSubscriptions[i])
                dbase.addEventRow(Event: mEvent) //add the database row to the table
            }
        }
        
        // Add sample data for Sustainability
        if (dbase.getAllTableContents(tablename: "Sustainability").count != 0){
            print("Data already added to Sustainability")
        } else{
            print("Adding data already added to Sustainability")
            for i in 0..<sampleData.sustainabilityTitles.count {
                //make the new database row
                mSustainability = Sustainability(name: sampleData.sustainabilityTitles[i], description: sampleData.sustainabilityDescriptions[i], imageURL: sampleData.sustainabilityPictures[i], location: "")
                dbase.addSustainabilityRow(Sustainability: mSustainability) // Add the database row to the table
            }
        }
        
        // Checks which category has been tapped on
        switch categoryID {
        case 0:
            self.title = "Events"
            filterBtn.isHidden = false
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            searchController.searchBar.placeholder = "Search " + self.title!
            print("events")
        case 1:
            self.title = "Sustainability"
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            searchController.searchBar.placeholder = "Search " + self.title!
            print("sustainability")
        case 2:
            self.title = "Clubs"
            filterBtn.isHidden = false
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            searchController.searchBar.placeholder = "Search " + self.title!
            print("clubs")
        default:
            print("default")
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            searchController.searchBar.placeholder = "Search here"
            
        }
        
        ClubsArray = dbase.getAllTableContents(tablename: "Club")//get all rows
        EventsArray = dbase.getAllTableContents(tablename: "Event")//get all rows
        SustainabilityArray = dbase.getAllTableContents(tablename: "Sustainability")//get all rows
    }
    
    func addTransparentView(frame: CGRect) {
        if let window = UIApplication.shared.delegate?.window {
            // Use the window here
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
        
        //        let window = UIApplication.shared.keyWindow
        
    }
    
    @objc func removeTransparentView() {
        let frames = selectedBtn.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.transparentView.alpha = 0
            self.dropDownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            
        }
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    // MARK: How many rows in the tableView?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        if tableView == self.cardTableView {
            switch categoryID {
            case 0:
                self.title = "Events"
                if isFiltering {
                    count = filteredObjects.count
                } else {
                    count = sampleData.eventTitles.count }
                
            case 1:
                self.title = "Sustainability"
                if isFiltering {
                    count = filteredObjects.count
                } else {
                    count = sampleData.sustainabilityTitles.count }
                
            case 2:
                self.title = "Clubs"
                if isFiltering {
                    count = filteredObjects.count
                } else {
                    count = sampleData.clubTitles.count
                }
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
            
            switch categoryID {
            case 0:
                print(EventsArray[indexPath.row])
                if isFiltering  {
                    // Checks if img is a url
                    getImg(urlString: filteredObjects[indexPath.row][3] as! String) { image in
                        cell.configure(id: (self.filteredObjects[indexPath.row][0] as? String)!,
                                       title: (self.filteredObjects[indexPath.row][1] as? String)!,
                                       description: (self.filteredObjects[indexPath.row][2] as? String)!,
                                       picture: image)
                    }
                    
                } else {
                    getImg(urlString: EventsArray[indexPath.row][3] as! String) { image in
                        cell.configure(id: (self.EventsArray[indexPath.row][0] as? String)!,
                                       title: (self.EventsArray[indexPath.row][1] as? String)!,
                                       description: (self.EventsArray[indexPath.row][2] as? String)!,
                                       picture: image,
                                       date: self.EventsArray[indexPath.row][4] as? String,
                                       location: self.EventsArray[indexPath.row][7] as? String)
                    }
                }
                
            case 1:
                if isFiltering  {
                    // Checks if img is a url
                    getImg(urlString: filteredObjects[indexPath.row][3] as! String) { image in
                        cell.configure(id: (self.filteredObjects[indexPath.row][0] as? String)!,
                                       title: (self.filteredObjects[indexPath.row][1] as? String)!,
                                       description: (self.filteredObjects[indexPath.row][2] as? String)!,
                                       picture: image)
                    }
                } else {
                    getImg(urlString: SustainabilityArray[indexPath.row][3] as! String) { image in
                        cell.configure(id: (self.SustainabilityArray[indexPath.row][0] as? String)!,
                                       title: (self.SustainabilityArray[indexPath.row][1] as? String)!,
                                       description: (self.SustainabilityArray[indexPath.row][2] as? String)!,
                                       picture: image)
                    }
                }
                
            case 2:
                if isFiltering  {
                    //checks if img is a url
                    getImg(urlString: filteredObjects[indexPath.row][3] as! String) { image in
                        cell.configure(id: (self.filteredObjects[indexPath.row][0] as? String)!,
                                       title: (self.filteredObjects[indexPath.row][1] as? String)!,
                                       description: (self.filteredObjects[indexPath.row][2] as? String)!,
                                       picture: image)
                    }
                } else {
                    getImg(urlString: ClubsArray[indexPath.row][3] as! String) { image in
                        cell.configure(id: (self.ClubsArray[indexPath.row][0] as? String)!,
                                       title: (self.ClubsArray[indexPath.row][1] as? String)!,
                                       description: (self.ClubsArray[indexPath.row][2] as? String)!,
                                       picture: image)
                    }
                }
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
                
                if categoryID == 0 || categoryID == 2 {
                    switch categoryID {
                    case 0:
                        if isFiltering {
                            vc.id = filteredObjects[indexPath.row][0] as? String
                            print("id Event")
                        } else {
                            vc.id = EventsArray[indexPath.row][0] as? String
                            print("id Event")
                        }
                    case 2:
                        if isFiltering {
                            vc.id = filteredObjects[indexPath.row][0] as? String
                            print("id Club")
                        } else {
                            vc.id = ClubsArray[indexPath.row][0] as? String
                            print("id Club")
                        }
                    default:
                        print("default")
                    }
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            if categoryID == 1 {
                if let vc = storyboard?.instantiateViewController(withIdentifier: "SustainabilityCardView") as? SustainabilityCardViewController
                {
                    if isFiltering {
                        vc.id = filteredObjects[indexPath.row][0] as? String
                        print("id Sus")
                    } else {
                        vc.id = SustainabilityArray[indexPath.row][0] as? String
                        print("id Sus")
                    }
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            //                switch categoryID {
            //                case 0:
            //                    if isFiltering {
            //                        vc.id = filteredObjects[indexPath.row][0] as? String
            //                        print("id Event")
            //                    } else {
            //                        vc.id = EventsArray[indexPath.row][0] as? String
            //                        print("id Event")
            //                    }
            //
            //                case 1:
            //                    if isFiltering {
            //                        vc.id = filteredObjects[indexPath.row][0] as? String
            //                        print("id Sus")
            //                    } else {
            //                        vc.id = SustainabilityArray[indexPath.row][0] as? String
            //                        print("id Sus")
            //                    }
            //
            //                case 2:
            //                    if isFiltering {
            //                        vc.id = filteredObjects[indexPath.row][0] as? String
            //                        print("id Club")
            //                    } else {
            //                        vc.id = ClubsArray[indexPath.row][0] as? String
            //                        print("id Club")
            //                    }
            //                default:
            //                    print("default")
            //                }
            //                navigationController?.pushViewController(vc, animated: true)
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
                case 2:
                    ClubsArray = ClubsArray.sorted(by: {
                        ("\(df.date(from: String(describing: $0[4] as! String) )! as Any)") < ("\(df.date(from: String(describing: $1[4] as! String) )! as Any)")
                    })
                default:
                    print("default")
                }
            }
            // Filter by less recent
            else {
                switch categoryID {
                case 0:
                    EventsArray = EventsArray.sorted(by: {
                        ("\(df.date(from: String(describing: $0[4] as! String) )! as Any)") > ("\(df.date(from: String(describing: $1[4] as! String) )! as Any)")
                    })
                    cardTableView.reloadData()
                case 2:
                    ClubsArray = ClubsArray.sorted(by: {
                        ("\(df.date(from: String(describing: $0[4] as! String) )! as Any)") > ("\(df.date(from: String(describing: $1[4] as! String) )! as Any)")
                    })
                default:
                    print("default")
                }
            }
            cardTableView.reloadData()
            removeTransparentView()
        }
        
    }
    
    @IBAction func filterBtn_Onclick(_ sender: Any) {
        dataSource = ["Most Recent", "Less Recent"]
        selectedBtn = filterBtn
        addTransparentView(frame: filterBtn.frame)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        switch categoryID {
            // Events
        case 0:
            filteredObjects = EventsArray.filter({ object in
                return( object[1] as! String ).lowercased().contains(searchText.lowercased())
            })
            
            //Sustainability
        case 1:
            filteredObjects = SustainabilityArray.filter({ object in
                return( object[1] as! String ).lowercased().contains(searchText.lowercased())
            })
            
            // Clubs
        case 2:
            filteredObjects = ClubsArray.filter( { object in
                return ( object[1] as! String ).lowercased().contains(searchText.lowercased())
            })
            
        default:
            print ("default")
            
        }
        cardTableView.reloadData()
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


// MARK: Search result updater
extension CardsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
        print(text)
    }
}
