//
//  mapViewController.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 10/22/22.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapkitView: MKMapView!
    var long: Double!
    var lat: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("long: \(long)    Lat: \(lat)")

        mapkitView.delegate = self
        mapkitView.mapType = .standard
        mapkitView.isZoomEnabled = true
        mapkitView.isScrollEnabled = true
        mapkitView.showsScale = true
        mapkitView.showsPointsOfInterest = true
        mapkitView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let sourceCoordinats = locationManager.location?.coordinate
        let destinationCoordinats = CLLocationCoordinate2DMake(lat, long)
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinats!)
        let destinationPlacemanrk = MKPlacemark(coordinate: destinationCoordinats)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemanrk)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response else{
                if let error = error{
                    print("Mapping fialed")
                }
                return
            }
            let route = response.routes[0]
            self.mapkitView.addOverlay(route.polyline, level: .aboveRoads)
            
            let mapScreen = route.polyline.boundingMapRect
            self.mapkitView.setRegion(MKCoordinateRegion(mapScreen), animated: true)
        })
        
        func mapView(_ mapView: MKMapView, renderFor overlay: MKOverlay) -> MKOverlayRenderer{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5
            return renderer
        }

            
    }
    
}
