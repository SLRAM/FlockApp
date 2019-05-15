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
import Kingfisher

class MapViewController: UIViewController {
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 55
    
    public var event: Event?
    public var guests: [InvitedModel]?
    private let authservice = AppDelegate.authservice
    private let mapView = MapView()
    var allGuestMarkers = [GMSMarker]()
    var hostMarker = GMSMarker()
    lazy var myTimer = Timer(timeInterval: 5.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    
    let locationManager = CLLocationManager()
    var usersCurrentLocation = CLLocation()
    var proximity = Double()    
    var guestCount = 0
    var resetMapToEvent = false
    var hostEvent: Event?
    var invited = [InvitedModel](){
        didSet{
            DispatchQueue.main.async {
//                self.eventView.peopleTableView.reloadData()
            }
        }
    }

    private var listener: ListenerRegistration!
    private var HostListener: ListenerRegistration!
    private var authService = AppDelegate.authservice

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Guests"

        guard let unwrappedEvent = event else {
            print("Unable to segue event")
            return
        }
        proximityCircle()
//        usersCurrentLocation = CLLocation(latitude: unwrappedEvent.locationLat, longitude: unwrappedEvent.locationLong)
        
        locationManager.delegate = self

        
        proximity = unwrappedEvent.proximity
        self.view.addSubview(mapView)
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //we need to say how accurate the data should be
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if isQuickEvent(eventType: unwrappedEvent) {
            
            proximityAlert()
        } else {
        }
        fetchEventLocation()
        fetchInvitedLocations()
        setupMapBounds()
        if let event = event, event.trackingTime.date() > Date() {
            print("start date is > ")

        } else {
            print("start date is < ")
            startTimer()
        }
        resetMapToEvent = true
    }
    
    func proximityCircle() {
        guard let unwrappedEvent = event else {
            print("Unable to obtain event for proximity circle")
            return}
        let prox = unwrappedEvent.proximity
        print("Event Proximity is \(prox)")
        let circleCenter = CLLocationCoordinate2D(latitude: unwrappedEvent.locationLat, longitude: unwrappedEvent.locationLong)
        let busStop = GMSCircle(position: circleCenter, radius: prox)
//        busStop.title = stop.name
//        #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        busStop.fillColor = UIColor.init(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5)
//        busStop.fillColor?.withAlphaComponent(0.8)
        busStop.map = self.mapView.myMapView
        let stopMarker = GMSMarker.init(position: circleCenter)
        stopMarker.snippet = busStop.title
        stopMarker.opacity = 0
        stopMarker.map = self.mapView.myMapView
    }
    
    func isQuickEvent(eventType: Event) -> Bool {
        if eventType.eventName == "On The Fly" || eventType.eventName == "Quick Event"{
            return true
        } else {
            return false
        }
    }

    func startTimer() {
        RunLoop.main.add(myTimer, forMode: RunLoop.Mode.default)
    }
    @objc func refresh() {
        guard let unwrappedEvent = event else {
            print("Unable to segue event")
            return
        }
        mapView.myMapView.clear()
        updateUserLocation()
        fetchInvitedLocations()
        fetchEventLocation()
        if let endDate = event?.endDate.date(), endDate < Date() {
            myTimer.invalidate()
        }
        if isQuickEvent(eventType: unwrappedEvent) {
            proximityAlert()
            proximityCircle()
        }
    }
    func updateUserLocation() {
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        guard let event = event else {return}
        if isQuickEvent(eventType: event) && user.uid == event.userID {
            
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
                .collection(EventsCollectionKeys.EventAcceptedKey)
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
        guard let event = event else {return}

        if isQuickEvent(eventType: event) {
            HostListener = DBService.firestoreDB
                .collection(EventsCollectionKeys.CollectionKey)
                .document(event.documentId)
                .addSnapshotListener({ [weak self] (snapshot, error) in
                    if let error = error {
                        print("failed to fetch events with error: \(error.localizedDescription)")
                    } else if let snapshot = snapshot,
                    let data = snapshot.data() {
                        self?.hostEvent = Event(dict: data)
                        DispatchQueue.main.async {
                            self?.allGuestMarkers.removeAll()
                            self?.setupMarkers(activeGuests: self!.invited)
                            
                            
                            if let eventLat = self?.hostEvent?.locationLat,
                            let eventLong = self?.hostEvent?.locationLong,
                            let eventName = self?.hostEvent?.eventName {
                                let eventLocation = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
                                if self?.resetMapToEvent == false {
                                    self?.mapView.myMapView.animate(to: GMSCameraPosition(latitude: eventLat, longitude: eventLong, zoom: 15))
                                }
                                guard let markerImage = UIImage(named: "birdhouse") else {return}
                                let eventMarker = GMSMarker.init()
                                let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: (self?.customMarkerWidth)!, height: (self?.customMarkerHeight)!), image: markerImage, borderColor: UIColor.darkGray, tag: 0)
                                
                                //        customMarker.backgroundColor = .white
                                eventMarker.position = eventLocation
                                eventMarker.title = eventName
                                //        eventMarker.icon = UIImage(named: "birdhouse")
                                eventMarker.iconView = customMarker
                                eventMarker.map = self?.mapView.myMapView
                                self?.hostMarker = eventMarker
                            }

                            
                            
                            
                            
                            //                    self?.refreshControl.endRefreshing()
                        }
                    }
                })
            
            
        } else {
            let eventLat = event.locationLat
            let eventLong = event.locationLong
            let eventName = event.eventName
            let eventLocation = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
            if resetMapToEvent == false {
                mapView.myMapView.animate(to: GMSCameraPosition(latitude: eventLat, longitude: eventLong, zoom: 15))
            }
            guard let markerImage = UIImage(named: "birdhouse") else {return}
            let eventMarker = GMSMarker.init()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: markerImage, borderColor: UIColor.darkGray, tag: 0)
            
            //        customMarker.backgroundColor = .white
            eventMarker.position = eventLocation
            eventMarker.title = eventName
            //        eventMarker.icon = UIImage(named: "birdhouse")
            eventMarker.iconView = customMarker
            eventMarker.map = mapView.myMapView
            hostMarker = eventMarker
        }

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

        for marker in self.allGuestMarkers {
            marker.map = nil
        }
        
        self.allGuestMarkers.removeAll()
        
        for guest in filteredGuests {
            guard let guestLat = guest.latitude,
                let guestLon = guest.longitude else {
                    print("unable to obtain guest coordinates for \(String(describing: event?.eventName))")
                    return
            }
            print("able to obtain guest coordinates for \(String(describing: event?.eventName))")
            let coordinate = CLLocationCoordinate2D.init(latitude: guestLat, longitude: guestLon)
            let marker = GMSMarker(position: coordinate)
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: URL(string: guest.photoURL ?? "no photo")!, borderColor: UIColor.darkGray, tag: count)
            marker.title = guest.displayName
            guard let task = guest.task else {return}
            marker.snippet = "task: \(task)"
            marker.iconView = customMarker
            allGuestMarkers.append(marker)
            
        
            count += 1
        }
        for marker in allGuestMarkers {
            DispatchQueue.main.async {
                
                marker.map = self.mapView.myMapView
            }
        }
//        self.mapView.myMapView.reloadInputViews()
        allGuestMarkers = guestDistanceFromEvent(markers: allGuestMarkers)
        if allGuestMarkers.count > guestCount {
                setupMapBounds()
            guestCount = allGuestMarkers.count
        }
        
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
        //if guests are beyond proximity then alert
        for guest in allGuestMarkers {
            
            let guestDistance = distance(from: guest.position, to: hostMarker.position)
            
            
            if guestDistance > proximity {
                print("\(String(describing: guest.title?.description)) is out of range by \(guestDistance) meters!")
            } else {
                print("\(String(describing: guest.title?.description)) is in range by \(guestDistance) meters!")
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
//        let distanceInFeet = (coordinate0.distance(from: coordinate1))/0.3048
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        return distanceInMeters
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
        
        let distanceFromUpdate = distance(from: usersCurrentLocation.coordinate, to: currentLocation.coordinate)
        //        distance >= (horizontalAccuracy * 0.5)
        print("distance from update \(distanceFromUpdate)")
        //        if distanceFromUpdate >= (currentLocation.horizontalAccuracy * 0.5) {
        //            print("Failed with : \(currentLocation.horizontalAccuracy * 0.5)")
        //        } else {
        //            print("passed with : \(currentLocation.horizontalAccuracy * 0.5)")
        //
        //            usersCurrentLocation = currentLocation
        //
        //        }
        usersCurrentLocation = currentLocation
        
    }
}
