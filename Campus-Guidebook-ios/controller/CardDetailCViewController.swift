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

class CardDetailViewController: UIViewController, EKEventEditViewDelegate, EKEventViewDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var locationNavButton: UIButton!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var subscriberCount: UILabel!
    
    
    
    let dbase: DatabaseHelper = DatabaseHelper()
    let RoomsClass: Rooms = Rooms()
    let eventStore = EKEventStore()
    let eventDeleteController = EKEventViewController()
    //    eventDeleteController.delegate = self
    
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
        autoPopulateItems()
    }
    
    func autoPopulateItems() {
        print("Card details View is loaded")
        df.dateFormat = "MM-dd-yyyy"
        
        switch categoryID {
        case 0:
            array = dbase.getRowByID(tableName: "Event", id: Int(id)!)
            print(array)
            startDateLabel.text = "Date: \(((array[0][4]) as? String)!)"
            startTimeLabel.text = "Time: \(((array[0][5]) as? String)!)"
            
            // -- GET DATE, START TIME, AND END TIME --
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
            // -- GET DATE, START TIME, AND END TIME --
            
            contactInfoLabel.text = "Contact: \(((array[0][6]) as? String)!)"
            LocationButtonText = (array[0][7]) as? String
            locationNavButton.setTitle("Take me here", for: .normal)//Set name of the map button
            subscribeButton.isHidden = false
            subscriberCount.text = "Number of attendees: \(((array[0][9]) as? String)!)"
            
            print("Coordinates of room: \(RoomsClass.getRoomCoordinatesByName(Room: String(LocationButtonText)))")
            print("Event ID")
        case 2:
            array = dbase.getRowByID(tableName: "Club", id: Int(id)!)
            startDateLabel.text = "Date: \(((array[0][4]) as? String)!)"
            startTimeLabel.text = "Time: \(((array[0][5]) as? String)!)"
            contactInfoLabel.text = "Contact: \(((array[0][6]) as? String)!)"
            LocationButtonText = (array[0][7]) as? String
            locationNavButton.setTitle("Take me here", for: .normal)
            
            print("Coordinates of room: \(RoomsClass.getRoomCoordinatesByName(Room: String(LocationButtonText)))")
            subscribeButton.isHidden = true
            print("Club ID")
            // case 3:
            // array = dbase.getRowByID(tableName: "Club", id: Int(id)!)
            // print("Club ID")
        default:
            print("default")
        }
        
        print( "Category id is \(categoryID!)")
        //            print(array)
        titleLabel.text = (array[0][1]) as? String
        descriptionLabel.text = "Description: \n\(((array[0][2]) as? String)!)"
        getImg(urlString: array[0][3] as! String) { image in
            DispatchQueue.main.async {
                self.imgView.image = image
            }
        }
    }
    
    @IBAction func nav(sender: UIButton) { // Segue trigger for navigating to imaps
        
        let RoomCoordinates: String = RoomsClass.getRoomCoordinatesByName(Room: String(LocationButtonText))
        
        let lat1 : NSString = RoomCoordinates.components(separatedBy: ", ")[0] as NSString
        let lng1 : NSString = RoomCoordinates.components(separatedBy: ",")[1] as NSString
        
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
    
    @IBAction func SubscribeToEvent(_ sender: Any) {
        let eventVC = EKEventEditViewController()
        eventVC.eventStore = eventStore
        eventVC.editViewDelegate = self
        
        let event = EKEvent(eventStore: eventVC.eventStore)
        event.title = self.titleLabel.text
        event.startDate = self.eventDateAndStartTime
        event.endDate = self.eventDateAndEndTime
        event.location = "location"
        
        // set alarm 5 minutes before event
        let alarm = EKAlarm(relativeOffset: TimeInterval(-2 * 86400))
        event.addAlarm(alarm)
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined, .authorized:
            eventStore.requestAccess(to: .event) { granted, error in
                if granted {
                    print("Authorized")
                    self.presentEventVC(eventStore: self.eventStore, event: event, eventVC: eventVC)
                } else {
                    print("Deauthorized")
                }
            }
        default:
            break
        }
    }
    
    func presentEventVC(eventStore: EKEventStore, event: EKEvent, eventVC: EKEventEditViewController) {
        if !eventAlreadyExists(event: event) {
            DispatchQueue.main.async {
                eventVC.event = event
                eventVC.eventStore = eventStore
                self.present(eventVC, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                
                let dialogMessage = UIAlertController(title: "View Event", message: "You're already subscribed, would you like to view your event?", preferredStyle: .alert)
                
                // Create view button with action handler
                let viewBtn = UIAlertAction(title: "View", style: .default, handler: { (action) -> Void in
                    let eventViewController = EKEventViewController()
                    eventViewController.delegate = self
                    eventViewController.event = event
                    let navigationcontroller = UINavigationController(rootViewController: eventViewController)
                    self.present(navigationcontroller, animated: true)
                })
                
                // Create cancel button with action handler
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
                    //                     print("cancel button tapped")
                })
                
                // Add buttons to a dialog message
                dialogMessage.addAction(viewBtn)
                dialogMessage.addAction(cancel)
                
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
            }
            
        }
    }
    
    private func eventAlreadyExists(event eventToAdd: EKEvent) -> Bool {
        let predicate = eventStore.predicateForEvents(withStart: eventToAdd.startDate, end: eventToAdd.endDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        
        let eventAlreadyExists = existingEvents.contains { (event) -> Bool in
            return eventToAdd.title == event.title && event.startDate == eventToAdd.startDate && event.endDate == eventToAdd.endDate
        }
        return eventAlreadyExists
    }
    
    func manageSubscriber(isAdding: Bool) {
        print("manage subscriber")
        var count: Int
        
        if let id = Int(id) {
            count = Int(dbase.getEventSubscriberCount(tableName: "Event", id: id))!
            print(count)
            if isAdding {
                count += 1
            } else {
                count -= 1
            }
            print(count)
            
            self.dbase.manageSubscription(counter: String(count), id: id)
            autoPopulateItems()
        }
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        
        if action == .saved {
            // The user has chosen to save the event
            if let event = controller.event {
                // The event property is not nil, so we can save the event to the calendar
                do {
                    // Set the event store for the event editor view controller
                    controller.eventStore = self.eventStore
                    
                    // Save the event to the calendar
                    try eventStore.save(event, span: .thisEvent, commit: true)
                    
                    // Increase the subscription counter
                    manageSubscriber(isAdding: true)
                    
                    //present the event
                    let eventVC = EKEventViewController()
                    eventVC.event = controller.event
                    eventVC.delegate = self
                    eventVC.modalPresentationStyle = .pageSheet
                    eventVC.preferredContentSize = CGSize(width: 0, height: 250)
                    self.present(eventVC, animated: true)
                } catch {
                    // An error occurred while trying to save the event
                    print("Error saving event: \(error)")
                }
            } else {
                // The event property is nil, so we cannot save the event to the calendar
                print("Error: event is nil, cannot save event to calendar")
            }
        }
    }
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        
        // Dismiss the event view controller
        controller.dismiss(animated: true, completion: nil)
        
        // Check the value of the action parameter
        if action == .deleted {
            // The user has chosen to delete the event
            if let event = controller.event {
                // The event property is not nil, so we can delete the event from the calendar
                do {
                    print("deleted event")
                    
                    // Decrease the subscription counter
                    manageSubscriber(isAdding: false)
                    
                    // match event with the one in event store
                    let predicate = eventStore.predicateForEvents(withStart: event.startDate, end: event.endDate, calendars: nil)
                    let existingEvents = eventStore.events(matching: predicate)
        
                    // Delete the event from the calendar
                    try eventStore.remove(existingEvents[0], span: .thisEvent, commit: true)

                    
                } catch {
                    // An error occurred while trying to delete the event
                    print("Error deleting event: \(error)")
                }
            } else {
                // The event property is nil, so we cannot delete the event from the calendar
                print("Error: event is nil, cannot delete event from calendar")
            }
        }
    }
    
    func eventViewControllerDidFinish(_ controller: EKEventViewController) {
        // Dismiss the view controller
        controller.dismiss(animated: true, completion: nil)
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




