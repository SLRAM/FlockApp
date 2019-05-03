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
import MapKit

class MapViewController: UIViewController {

//    var mapView: GMSMapView?

    public var event: Event?
    private let authservice = AppDelegate.authservice
    private let mapView = MapView()
    var allGuestMarkers = [GMSMarker]()
    var hostMarker = GMSMarker()
    lazy var myTimer = Timer(timeInterval: 10.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    
    let locationManager = CLLocationManager()
    var usersCurrentLocation = CLLocation()
    var proximity = Double()
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
        proximity = unwrappedEvent.proximity
        self.view.addSubview(mapView)
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //we need to say how accurate the data should be
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if isQuickEvent(eventType: unwrappedEvent) {
//            quickEventMap(unwrappedEvent: unwrappedEvent)
        } else {
//            standardEventMap(unwrappedEvent: unwrappedEvent)
        }
        
        
        
        fetchEventLocation()
        fetchInvitedLocations()

        if let event = event, event.trackingTime.date() > Date() {
            print("start date is > ")

        } else {
            print("start date is < ")
            startTimer()
        }

    }
    
    func isQuickEvent(eventType: Event) -> Bool {
        if eventType.eventName == "Quick Event" {
            return true
        } else {
            return false
        }
    }

    func startTimer() {
        RunLoop.main.add(myTimer, forMode: RunLoop.Mode.default)
    }
    @objc func refresh() {
        updateUserLocation()
        fetchInvitedLocations()
        fetchEventLocation()
        if let endDate = event?.endDate.date(), endDate < Date() {
            //invalidate timer
            myTimer.invalidate()
        }
        
    }
    func updateUserLocation() {
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        guard let event = event else {return}
        
        if isQuickEvent(eventType: event) {
            
            
            DBService.firestoreDB
                .collection(EventsCollectionKeys.CollectionKey)
                .document(event.documentId)
                .updateData([EventsCollectionKeys.LocationLatKey : usersCurrentLocation.coordinate.latitude,
                             EventsCollectionKeys.LocationLongKey: usersCurrentLocation.coordinate.longitude
                ]) { [weak self] (error) in
                    if let error = error {
                        self?.showAlert(title: "Editing event document Error", message: error.localizedDescription)
                    }
            }
            DBService.firestoreDB
                .collection(UsersCollectionKeys.CollectionKey)
                .document(user.uid)
                .collection(EventsCollectionKeys.CollectionKey)
                .document(event.documentId)
                .updateData([EventsCollectionKeys.LocationLatKey : usersCurrentLocation.coordinate.latitude,
                             EventsCollectionKeys.LocationLongKey: usersCurrentLocation.coordinate.longitude
                ]) { [weak self] (error) in
                    if let error = error {
                        self?.showAlert(title: "Editing event document on user Error", message: error.localizedDescription)
                    }
            }
            
        } else {
            DBService.firestoreDB
                .collection(EventsCollectionKeys.CollectionKey)
                .document(event.documentId)
                .collection(InvitedCollectionKeys.CollectionKey)
                .document(user.uid)
                .updateData([InvitedCollectionKeys.LatitudeKey : usersCurrentLocation.coordinate.latitude,
                             InvitedCollectionKeys.LongitudeKey: usersCurrentLocation.coordinate.longitude
                ]) { [weak self] (error) in
                    if let error = error {
                        self?.showAlert(title: "Editing Error", message: error.localizedDescription)
                    }
            }
        }
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
        eventMarker.icon = UIImage(named: "birdhouse")
        eventMarker.map = mapView.myMapView
        hostMarker = eventMarker
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
        let filteredGuests = activeGuests.filter {
            $0.latitude != nil
        }
        for guest in filteredGuests {
            guard let guestLat = guest.latitude,
                let guestLon = guest.longitude else {
                    print("unable to obtain guest coordinates for \(String(describing: event?.eventName))")
                    return
            }
            print("able to obtain guest coordinates for \(String(describing: event?.eventName))")
//            let guestLat = guest.latitude
//            let guestLon = guest.longitude
            let coordinate = CLLocationCoordinate2D.init(latitude: guestLat, longitude: guestLon)
            let marker = GMSMarker(position: coordinate)
            marker.title = guest.displayName
            guard let task = guest.task else {return}
            marker.snippet = "task: \(task)"
            marker.icon = UIImage(named: "icons8-bird-30")
            allGuestMarkers.append(marker)
            DispatchQueue.main.async {
                marker.map = self.mapView.myMapView
            }
            count += 1
        }
        allGuestMarkers = guestDistanceFromEvent(markers: allGuestMarkers)
        setupMapBounds()
        
        
    }
    func boundsNumber(guests: [GMSMarker]) -> Int? {
        if guests.count >= 3 {
            return 2
        } else if guests.count > 0 {
            return guests.count - 1
        } else {
            return nil
        }
    }
    func proximityAlert() {
        //if guests are beyond prximity then alert
        for guest in allGuestMarkers {
            if distance(from: guest.position, to: hostMarker.position) > proximity {
                print("\(String(describing: guest.title?.description)) is out of range!")
            }

        }
    }
    func setupMapBounds() {
        guard let event = event else {
            print("Unable to segue event")
            return
        }
        let eventCoordinates = CLLocationCoordinate2D(latitude: event.locationLat, longitude: event.locationLong)
        if let guestNumber = boundsNumber(guests: allGuestMarkers) {
            let guestCoordinate = allGuestMarkers[guestNumber].position
            mapView.myMapView.moveCamera(GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: eventCoordinates, coordinate: guestCoordinate)))
        }
        if isQuickEvent(eventType: event) {
            proximityAlert()
        }
    }
    func guestDistanceFromEvent(markers: [GMSMarker]) -> [GMSMarker] {
        guard let event = event else {
            print("Unable to segue event")
            return markers
        }
        let eventCoordinates = CLLocationCoordinate2D(latitude: event.locationLat, longitude: event.locationLong)
        let sortedMarkers = markers.sorted { markerOne, markerTwo in
            let distanceOne = distance(from: markerOne.position, to: eventCoordinates)
            let distanceTwo = distance(from: markerTwo.position, to: eventCoordinates)
            return distanceOne < distanceTwo
            }
        return sortedMarkers
    }
    public func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let coordinate0 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let coordinate1 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        let distanceInMiles = (coordinate0.distance(from: coordinate1))/1609.344
        return distanceInMiles
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

