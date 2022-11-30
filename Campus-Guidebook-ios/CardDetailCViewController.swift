//
//  CardDetailViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 5/24/22.
//

import UIKit
import MapKit
import CoreLocation
import EventKit
import EventKitUI

class CardDetailViewController: UIViewController, EKEventEditViewDelegate {
    
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    // Add date, time, location, and contactUrl properties for IBoutlet here
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var locationNavButton: UIButton!
    
    
    
    @IBAction func nav(sender: UIButton) {//Segue trigger for navigating to imaps
        
        let RoomCoordinates: String = RoomsClass.getRoomCoordinatesByName(Room: String(LocationButtonText))
        
        let lat1 : NSString = RoomCoordinates.components(separatedBy: ", ")[0] as NSString
        let lng1 : NSString = RoomCoordinates.components(separatedBy: ", ")[1] as NSString
            
            let latitude:CLLocationDegrees =  lat1.doubleValue
            let longitude:CLLocationDegrees =  lng1.doubleValue
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(String(describing: titleLabel.text!))"
        mapItem.openInMaps(launchOptions: options)
        
    }
    //    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    
    let dbase: DatabaseHelper = DatabaseHelper()
    let RoomsClass: Rooms = Rooms()
    let eventStore = EKEventStore()
    
    var categoryID: Int!
    var id: String!
    var array = [[Any]]()
    var LocationButtonText: String!
    
    var eventStartAndEndTimeArray: [String]!
    var eventDate: Date!
    var eventDateAndStartTime: Date!
    var eventDateAndEndTime: Date!
    var eventStartTime: String!
    var eventEndTime: String!
    var eventEndDate: Date!
    var df = DateFormatter()
    var dc = DateComponents()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Card details View is loaded")
        df.dateFormat = "MM-dd-yyyy"
        
        switch categoryID {
        case 0:
            array = dbase.getRowByID(tableName: "Event", id: Int(id)!)
            startDateLabel.text = "Date: \(((array[0][4]) as? String)!)"
            startTimeLabel.text = "Time: \(((array[0][5]) as? String)!)"
            
            //GET DATE, START TIME, AND END TIME
            eventDate = df.date(from: ((array[0][4]) as? String)!)
            eventEndDate = df.date(from: ((array[0][4]) as? String)!)
            
            eventStartAndEndTimeArray = ((array[0][5]) as? String)!.components(separatedBy: " - ")
            eventStartTime = eventStartAndEndTimeArray[0]
            eventEndTime = eventStartAndEndTimeArray[1]
            
            df.dateFormat = "h:mm a"
            let date = df.date(from: eventStartTime)
            let date2 = df.date(from: eventEndTime)
            df.dateFormat = "HH:mm"
            
            
            let Date24 = df.string(from: date!)
            let Date24StartTimeArray = String(Date24).components(separatedBy: ":")

            let Date24EndTime = df.string(from: date2!)
            let Date24EndTimeArray = String(Date24EndTime).components(separatedBy: ":")
            
            dc.hour = Int(Date24StartTimeArray[0])
            dc.minute = Int(Date24StartTimeArray[1])
            eventDateAndStartTime = Calendar.current.date(byAdding: dc, to: eventDate)
            
            dc.hour = Int(Date24EndTimeArray[0])
            dc.minute = Int(Date24EndTimeArray[1])
            eventDateAndEndTime = Calendar.current.date(byAdding: dc, to: eventEndDate)
            //GET DATE, START TIME, AND END TIME
            contactInfoLabel.text = "Contact: \(((array[0][6]) as? String)!)"
            LocationButtonText = (array[0][7]) as? String
            locationNavButton.setTitle("Take me here", for: .normal)//Set name of the map button
            subscribeButton.isHidden = false
            
            print("Coordinates of room: \(RoomsClass.getRoomCoordinatesByName(Room: String(LocationButtonText)))")
            print("Event ID")
        case 1:
            array = dbase.getRowByID(tableName: "Sustainability", id: Int(id)!)
            startDateLabel.isHidden = true
            startTimeLabel.isHidden = true
            contactInfoLabel.isHidden = true
            subscribeButton.isHidden = true
            print("Sus ID")
        case 2:
            array = dbase.getRowByID(tableName: "Club", id: Int(id)!)
            startDateLabel.text = "Date: \(((array[0][4]) as? String)!)"
            startTimeLabel.text = "Time: \(((array[0][5]) as? String)!)"
            contactInfoLabel.text = "Contact: \(((array[0][6]) as? String)!)"
            LocationButtonText = (array[0][7]) as? String
                        locationNavButton.setTitle("Take me here", for: .normal)
            subscribeButton.isHidden = true
            print("Club ID")
        case 3:
                    array = dbase.getRowByID(tableName: "Club", id: Int(id)!)
                    print("Club ID")
        default:
            print("default")
        }
        
        print( "Category id is \(categoryID!)")
        
        print(array)
        titleLabel.text = (array[0][1]) as? String
        descriptionLabel.text = "Description: \n\(((array[0][2]) as? String)!)"
        let image = getImg(urlString: array[0][3] as! String)
        imgView.image = image

        

        
//        dateLabel.text = (array[0][4]) as? String
//        locationButton.text = (array[0][7]) as? String
        
    }
    
    @IBAction func SubscribeToEvent(_ sender: Any) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            eventStore.requestAccess(to: .event) { granted, error in
                if granted {
                    print("Authorized")
                    presentEventVC()
                }
            }
        case .authorized:
            print("Authorized")
            presentEventVC()
        default:
            break
        }
        
        func presentEventVC() {
            
            let eventVC = EKEventEditViewController()
            eventVC.editViewDelegate = self
            eventVC.eventStore = EKEventStore()
            
            let event = EKEvent(eventStore: eventVC.eventStore)
            event.title = titleLabel.text
            event.startDate = eventDateAndStartTime
            event.endDate = eventDateAndEndTime
            
            // set alarm 5 minutes before event
            let alarm = EKAlarm(relativeOffset: TimeInterval(-2 * 86400))
            event.addAlarm(alarm)
            
            if !checkEventExists(store: eventVC.eventStore, event: event) {
                eventVC.event = event
                self.present(eventVC, animated: true, completion: nil)
            }
            else {
                // Create new Alert
                 var dialogMessage = UIAlertController(title: "Confirm", message: "Event already exists.", preferredStyle: .alert)
                 
                 // Create OK button with action handler
                 let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                     print("Ok button tapped")
                  })
                 
                 //Add OK button to a dialog message
                 dialogMessage.addAction(ok)
                 // Present Alert to
                 self.present(dialogMessage, animated: true, completion: nil)
            }
            
        }
    }
    
    func checkEventExists(store: EKEventStore, event eventToAdd: EKEvent) -> Bool {
        let predicate = store.predicateForEvents(withStart: eventToAdd.startDate, end: eventToAdd.endDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)

        let exists = existingEvents.contains { (event) -> Bool in
            return eventToAdd.title == event.title && event.startDate == eventToAdd.startDate && event.endDate == eventToAdd.endDate
        }
        return exists
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
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
    // MARK: - Navigation to maps page
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //NAVIGATION
    //    if segue.identifier == "MapToLocation" {
    //        if let nextViewController = segue.destination as? mapViewController {
    //            nextViewController.long = Double(LocationButtonText.components(separatedBy: ", ")[0])
    //            nextViewController.lat = Double(LocationButtonText.components(separatedBy: ", ")[1])
    //        }
    //    }
    //}
}

//extension UIImage {
//
//    convenience init?(withContentsOfUrl url: URL) throws {
//        let imageData = try Data(contentsOf: url)
//
//        self.init(data: imageData)
//    }
//}
