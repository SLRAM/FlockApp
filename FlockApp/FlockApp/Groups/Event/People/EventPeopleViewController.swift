//
//  EventPeopleViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import CoreLocation
import MapKit

class EventPeopleViewController: UIViewController {
    
    public var personToSet: InvitedModel?
    public var event: Event?
    private let authservice = AppDelegate.authservice
    private let mapView = MapView()
    var hostMarker = GMSMarker()
    lazy var myTimer = Timer(timeInterval: 10.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    
    let locationManager = CLLocationManager()
    var usersCurrentLocation = CLLocation()
    private var listener: ListenerRegistration!
    private var authService = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let unwrappedPerson = personToSet else {
            print("unable to segue person")
            return
        }
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //we need to say how accurate the data should be
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    func startTimer() {
        RunLoop.main.add(myTimer, forMode: RunLoop.Mode.default)
    }
    
    @objc func refresh() {
        updateUserLocation()
        fetchInvitedLocations()
        if let endDate = event?.endDate.date(), endDate < Date() {
            //invalidate timer
            myTimer.invalidate()
        }
        
    }
    
    
    extension MapViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            //this kicks off whenever authorization is turned on or off
            print("user changed the authorization")
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            //this kicks off whenever the user's location has noticeably changed
            print("user has changed locations")
            guard let currentLocation = locations.last else {return}
            print("The user is in lat: \(currentLocation.coordinate.latitude) and long:\(currentLocation.coordinate.longitude)")
            usersCurrentLocation = currentLocation
            
        }
    
}
