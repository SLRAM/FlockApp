//
//  MapViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import GoogleMaps
//import GooglePlaces
import Firebase
import FirebaseFirestore
import CoreLocation

class MapViewController: UIViewController {

//    var mapView: GMSMapView?

    public var event: Event?
    private let mapView = MapView()
    var allGuestMarkers = [GMSMarker]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
//    var placesClient: GMSPlacesClient!
    
    var invited = [InvitedModel](){
        didSet{
            DispatchQueue.main.async {
//                self.eventView.peopleTableView.reloadData()
            }
        }
    }

    private var listener: ListenerRegistration!
    private var authService = AppDelegate.authservice

    

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        guard let unwrappedEvent = event else {
            print("Unable to segue event")
            return
        }
        self.view.addSubview(mapView)
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //we need to say how accurate the data should be
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
//            mapView.showsUserLocation = true
//            mapView.sh
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
//            mapView.showsUserLocation = true
        }
        
        
        
        fetchEventLocation()
        fetchInvitedLocations()
//        mapView.myMapView.animate(toLocation: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
        
    }
    func timer() {
        let myTimer = Timer(timeInterval: 20.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        RunLoop.main.add(myTimer, forMode: RunLoop.Mode.default)
    }
    @objc func refresh() {
        fetchInvitedLocations()
    }
    func fetchEventLocation() {
        guard let eventLat = event?.locationLat,
            let eventLong = event?.locationLong,
        let eventName = event?.eventName else {
                print("unable to locate event")
                return
        }
        let eventLocation = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
//        mapView.myMapView.animate(toLocation: eventLocation)
        mapView.myMapView.animate(to: GMSCameraPosition(latitude: eventLat, longitude: eventLong, zoom: 15))
//        GMSCameraUpdate.zoom(to: 1)
        let eventMarker = GMSMarker.init()
        eventMarker.position = eventLocation
        eventMarker.title = eventName
        eventMarker.map = mapView.myMapView
    }
    func fetchInvitedLocations() {
        guard let unwrappedEvent = event else {
            print("Unable to segue event")
            return
        }
        listener = DBService.firestoreDB
            .collection(EventsCollectionKeys.CollectionKey)
            .document(unwrappedEvent.documentId)
            .collection(InvitedCollectionKeys.CollectionKey)
            .addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch events with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot{
                    self?.invited = snapshot.documents.map{InvitedModel(dict: $0.data()) }
                        .sorted { $0.displayName > $1.displayName}
                    DispatchQueue.main.async {
                        self?.allGuestMarkers.removeAll()
                        self?.setupMarkers(activeGuests: self!.invited)
                        //                    self?.refreshControl.endRefreshing()
                    }
                }

            })
    }
    func setupMarkers(activeGuests: [InvitedModel]){
        
        var count = 0
        
        for guest in activeGuests {
            let guestLat = guest.latitude
            let guestLon = guest.longitude
            let coordinate = CLLocationCoordinate2D.init(latitude: guestLat, longitude: guestLon)
            let marker = GMSMarker(position: coordinate)
            marker.title = guest.displayName
            guard let task = guest.task else {return}
            marker.snippet = "task: \(task)"
            marker.icon = GMSMarker.markerImage(with: #colorLiteral(red: 0.0208575353, green: 0.7171841264, blue: 0.6636909246, alpha: 1))
            allGuestMarkers.append(marker)
            DispatchQueue.main.async {
                marker.map = self.mapView.myMapView
            }
            count += 1
        }
    }
    


}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //this kicks off whenever authorization is turned on or off
        print("user changed the authorization")
        
//        let currentLocation = mapView.userLocation
//        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//
//        myMapView.setRegion(myCurrentRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this kicks off whenever the user's location has noticeably changed
        print("user has changed locations")
        guard let currentLocation = locations.last else {return}
        print("The user is in lat: \(currentLocation.coordinate.latitude) and long:\(currentLocation.coordinate.longitude)")
        
//        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//
//        myMapView.setRegion(myCurrentRegion, animated: true)
    }
}
