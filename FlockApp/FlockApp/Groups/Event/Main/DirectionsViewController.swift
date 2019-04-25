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

class DirectionsViewController: UIViewController {
    
    public var event: Event?
    private let mapView = DirectionsView()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    private var listener: ListenerRegistration!
    private var authService = AppDelegate.authservice

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEventLocation()

    }
    
    
    func fetchEventLocation() {
        guard let venueLat = self.event?.locationLat,
            let venueLong = self.event?.locationLong else {return}
        let coordinate = CLLocationCoordinate2DMake(venueLat,venueLong)
        let coordinate2 = CLLocationCoordinate2DMake(MKUserLocation, <#T##longitude: CLLocationDegrees##CLLocationDegrees#>)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        let mapItem2 = MKMapItem(placemark: MKPlacemark(coordinate: coordinate2))
        mapItem.name = self.event?.eventName
//        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
}
