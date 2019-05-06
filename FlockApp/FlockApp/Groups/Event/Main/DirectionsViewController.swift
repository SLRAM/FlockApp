//
//  DirectionsViewController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/25/19.
//

import UIKit
import MapKit
import Firebase
import FirebaseFirestore
import CoreLocation

class DirectionsViewController: UIViewController, CLLocationManagerDelegate {
    
    public var event: Event?
    private let mapView = DirectionsView()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    
    private var listener: ListenerRegistration!
    private var authService = AppDelegate.authservice

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEventLocation()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //we need to say how accurate the data should be
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            //            myMapView.showsUserLocation = true
            //            mapView.sh
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            //            myMapView.showsUserLocation = true


    }
        mapView.mapView.delegate = self
    
    }
    
//    var lat1 : NSString = self.venueLat
//    var lng1 : NSString = self.venueLng
//
//    var latitude:CLLocationDegrees =  lat1.doubleValue
//    var longitude:CLLocationDegrees =  lng1.doubleValue
//
//    var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
//
//    var placemark : MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary:nil)
//
//    var mapItem:MKMapItem = MKMapItem(placemark: placemark)
//
//    mapItem.name = "Target location"
//
//    let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey)
//
//    var currentLocationMapItem:MKMapItem = MKMapItem.mapItemForCurrentLocation()
//
//    MKMapItem.openMapsWithItems([currentLocationMapItem, mapItem], launchOptions: launchOptions)
    

    func fetchEventLocation() {
        guard let venueLat = self.event?.locationLat,
        let venueLong = self.event?.locationLong else {return}
        let coordinate = CLLocationCoordinate2DMake(venueLat,venueLong)
        
        let placemark:MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        let mapItem:MKMapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(event?.eventName)"
        
    
        let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey as NSCopying)
        
        let currentLocationMapItem:MKMapItem = MKMapItem.forCurrentLocation()
        
        MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: launchOptions as! [String : Any])
        
        
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
//        let mapItem2 = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation!))
//        let mapItem3 = MKMapItem()
//        pl.name = self.event?.eventName
        
        
        
//        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
}

extension DirectionsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotation.markerTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        annotation.glyphImage = UIImage(named: "icons8-bird-30")
        return annotation
    }
    
//    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//    annotationView.markerTintColor = UIColor.init(displayP3Red: 247/255, green: 195/255, blue: 106/255, alpha: 1)
//    annotationView.glyphImage =  UIImage(named: "wifi")
//    return annotationView
    
}
