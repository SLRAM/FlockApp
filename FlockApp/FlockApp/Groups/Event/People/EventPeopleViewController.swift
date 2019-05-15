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
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    public var event: Event?
    public var personToSet: InvitedModel?
    public var invited = [InvitedModel]()
    private let authservice = AppDelegate.authservice
    private let mapView = EventPeopleView()
    var allGuestMarkers = [GMSMarker]()
    var hostMarker = GMSMarker()
    lazy var myTimer = Timer(timeInterval: 10.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    
    let locationManager = CLLocationManager()
    var usersCurrentLocation = CLLocation()
    var proximity = Double()
    var guestCount = 0
    var resetMapToEvent = false
    
    
    private var listener: ListenerRegistration!
    private var authService = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedEvent = event else {
            print("unable to segue person")
            return
        }
        
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
        }
        fetchUser()
        setupMapBounds()
        if let event = event, event.trackingTime.date() > Date() {
            print("start date is > ")
            
        } else {
            print("start date is < ")
            startTimer()
        }
        resetMapToEvent = true
        
    }
    
    func startTimer() {
        RunLoop.main.add(myTimer, forMode: RunLoop.Mode.default)
    }
    
    @objc func refresh() {
        fetchUser()
        if let endDate = event?.endDate.date(), endDate < Date() {
            //invalidate timer
            myTimer.invalidate()
        }
        
        
    }
    func isQuickEvent(eventType: Event) -> Bool {
        if eventType.eventName == "Quick Event" {
            return true
        } else {
            return false
        }
    }
    
    func fetchUser() {
        guard let unwrappedEvent = event else {
            print("Unable to segue event")
            return
        }
        guard let person = personToSet else {
            print("blah")
            return
        }
        
//        if let pLat = person.latitude {
//            if let pLong = person.longitude {
//                mapView.myMapView.animate(to: GMSCameraPosition(latitude: pLat, longitude: pLong, zoom: 15))
//            }
//        } else {
//            // Change this to the event location or host location that already exist 100%
//            mapView.myMapView.animate(to: GMSCameraPosition(latitude: person.latitude!, longitude: person.longitude!, zoom: 15))
//        }
        
        if let personLat = person.latitude, let personLon = person.longitude {
            mapView.myMapView.animate(to: GMSCameraPosition(latitude: personLat, longitude: personLon, zoom: 15))
        } else {
            mapView.myMapView.animate(to: GMSCameraPosition(latitude: event!.locationLat, longitude: event!.locationLong, zoom: 15))
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
                        .filter {$0.userId == person.userId }
                    DispatchQueue.main.async {
                        //call function for setting markers
                        self!.setupMarkers(activeGuests: self!.invited)
                        //                        self?.allGuestMarkers.removeAll() self!.invited)
                        //                    self?.refreshControl.endRefreshing()
                    }
                }
            })
    }
    
    
    func setupMarkers(activeGuests: [InvitedModel]) {
        
        let guests = invited.filter {
            $0.latitude != nil
        }
        
        for guest in guests {
            guard let guestLat = guest.latitude,
                let guestLon = guest.longitude else {
                    print("unable to obtain guest coordinates for \(String(describing: event?.eventName))")
                    return
            }
            print("able to obtain guest coordinates for \(String(describing: event?.eventName))")
            let coordinate = CLLocationCoordinate2D.init(latitude: guestLat, longitude: guestLon)
            let marker = GMSMarker(position: coordinate)
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: URL(string: guest.photoURL ?? "no photo")!, borderColor: UIColor.darkGray, tag: 0)
            marker.title = guest.displayName
            guard let task = guest.task else {return}
            marker.snippet = "task: \(task)"
            marker.iconView = customMarker
            marker.map = self.mapView.myMapView
        }
        
//        hostMarker.map = nil
//
//        if guest.count == 1 {
//
//        guard let guestLat = guest[0].latitude,
//            let guestLon = guest[0].longitude else {
//                print("unable to obtain guest coordinates for \(String(describing: event?.eventName))")
//                return
//        }
//
//        let coordinate = CLLocationCoordinate2D.init(latitude: guestLat, longitude: guestLon)
//        let marker = GMSMarker(position: coordinate)
//        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: URL(string: guest[0].photoURL ?? "no photo")!, borderColor: UIColor.darkGray, tag: 0)
//        marker.title = guest[0].displayName
//        guard let task = guest[0].task else {return}
//        marker.snippet = "task: \(task)"
//        marker.iconView = customMarker
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
                print("\(String(describing: guest.title?.description)) is out of range by \(guestDistance) feet!")
            } else {
                print("\(String(describing: guest.title?.description)) is in range by \(guestDistance) feet!")
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

    public func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let coordinate0 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let coordinate1 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        //        let distanceInFeet = (coordinate0.distance(from: coordinate1))/0.3048
        let distanceInFeet = coordinate0.distance(from: coordinate1)
        return distanceInFeet
    }
}
