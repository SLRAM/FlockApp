//
//  MapViewController.swift
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
import Kingfisher

class MapViewController: UIViewController {
	let customMarkerWidth: Int = 50
	let customMarkerHeight: Int = 55
	
	public var event: Event?
	public var guests: [InvitedModel]?
	private let authservice = AppDelegate.authservice
	private let mapView = MapView()
	var allGuestMarkers = [GMSMarker]()
	var allOutOfRangeGuests = [(GuestName: String, GuestDistance: Double)]()
	var proximityCircleMarker = GMSCircle()
	var hostEventMarker = GMSMarker()
	lazy var myTimer = Timer(timeInterval: 5.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
	
	let locationManager = CLLocationManager()
	var usersCurrentLocation = CLLocation()
	var proximity = Double()
	var guestCount = 0
	var resetMapToEvent = false
	var proximityPassed = false
	var hostEvent: Event?
	var invited = [InvitedModel]()
	
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
		locationManager.delegate = self
		proximity = unwrappedEvent.proximity
		self.view.addSubview(mapView)
		
		mapView.myMapView.setMinZoom(10, maxZoom: 18)
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			//we need to say how accurate the data should be
			locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
			locationManager.startUpdatingLocation()
		} else {
			locationManager.requestWhenInUseAuthorization()
			locationManager.startUpdatingLocation()
		}
		if isQuickEvent(eventType: unwrappedEvent) && proximityPassed == false {
			proximityAlert()
			proximityCircle()
		} else if isQuickEvent(eventType: unwrappedEvent) && proximityPassed == true {
			proximityCircle()
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
	}
	
	func proximityCircle() {
		proximityCircleMarker.map = nil
		guard let unwrappedEvent = event else {
			print("Unable to obtain event for proximity circle")
			return}
		var updatedEvent = unwrappedEvent
		let prox = unwrappedEvent.proximity
		print("Event Proximity is \(prox)")
		DBService.firestoreDB
			.collection(EventsCollectionKeys.CollectionKey)
			.document(unwrappedEvent.documentId)
			.getDocument { (snapshot, error) in
				if let error = error {
					self.showAlert(title: "Updating Event Location Error", message: error.localizedDescription)
				} else if let snapshot = snapshot {
					updatedEvent = Event(dict: snapshot.data()!)
					let circleCenter = CLLocationCoordinate2D(latitude: updatedEvent.locationLat, longitude: updatedEvent.locationLong)
					self.proximityCircleMarker = GMSCircle(position: circleCenter, radius: prox)
					self.proximityCircleMarker.fillColor = UIColor.init(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5)
					self.proximityCircleMarker.map = self.mapView.myMapView
					let eventMarker = GMSMarker.init(position: circleCenter)
					eventMarker.snippet = self.proximityCircleMarker.title
					eventMarker.opacity = 0
					eventMarker.map = self.mapView.myMapView
				}
		}
	}
	
	func isQuickEvent(eventType: Event) -> Bool {
		if eventType.eventName == "On The Fly" {
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
		updateUserLocation()
		fetchEventLocation()
		fetchInvitedLocations()
		if let endDate = event?.endDate.date(), endDate < Date() {
			myTimer.invalidate()
		}
		
		if isQuickEvent(eventType: unwrappedEvent) && proximityPassed == false {
			proximityAlert()
			proximityCircle()
		} else if isQuickEvent(eventType: unwrappedEvent) && proximityPassed == true {
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
			self.hostEventMarker.map = nil
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
							if let eventLat = self?.hostEvent?.locationLat,
								let eventLong = self?.hostEvent?.locationLong,
								let eventName = self?.hostEvent?.eventName {
								let eventLocation = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
								if self?.resetMapToEvent == false {
									self?.mapView.myMapView.animate(to: GMSCameraPosition(latitude: eventLat, longitude: eventLong, zoom: 20))
									self?.resetMapToEvent = true
								}
								guard let markerImage = UIImage(named: "birdhouse") else {return}
								let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: (self?.customMarkerWidth)!, height: (self?.customMarkerHeight)!), image: markerImage, borderColor: UIColor.darkGray, tag: 0)
								self?.hostEventMarker.position = eventLocation
								self?.hostEventMarker.title = eventName
								self?.hostEventMarker.iconView = customMarker
								self?.hostEventMarker.map = self?.mapView.myMapView
							}
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
				self.resetMapToEvent = true
			}
			guard let markerImage = UIImage(named: "birdhouse") else {return}
			let eventMarker = GMSMarker.init()
			let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: markerImage, borderColor: UIColor.darkGray, tag: 0)
			eventMarker.position = eventLocation
			eventMarker.title = eventName
			eventMarker.iconView = customMarker
			eventMarker.map = mapView.myMapView
			hostEventMarker = eventMarker
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
						self?.setupMarkers(activeGuests: self!.invited)
					}
				}
			})
	}
	func setupMarkers(activeGuests: [InvitedModel]){
		var count = 0
		
		let filteredGuests = activeGuests.filter {
			$0.latitude != nil || $0.longitude != nil
		}.sorted(by: {Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue($0.latitude!)) < Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue($1.latitude!))}).sorted(by: {Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue($0.longitude!)) < Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue($1.longitude!))})
//		print("the guests are: \(filteredGuests)")
		for guest in filteredGuests {
			print("the guests are: \(guest.fullName)")
		}

		for guest in filteredGuests {
			//if lat and long are <100 difference then group
			guard let guestLat = guest.latitude,
				let guestLon = guest.longitude else {
					print("unable to obtain guest coordinates for \(String(describing: event?.eventName))")
					return
			}
			print("able to obtain guest coordinates for \(String(describing: event?.eventName))")
			let coordinate = CLLocationCoordinate2D.init(latitude: guestLat, longitude: guestLon)
			let marker = GMSMarker(position: coordinate)
			marker.userData = guest.userId
			let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: URL(string: guest.photoURL ?? "")!, borderColor: UIColor.darkGray, tag: count)
			marker.title = guest.displayName
			guard let task = guest.task else {return}
			marker.snippet = "task: \(task)"
			marker.iconView = customMarker
			marker.zIndex = Int32(count)
			if allGuestMarkers.contains(where: { $0.userData as! String == guest.userId }) {
				for activeMarker in allGuestMarkers {
					if activeMarker.userData as! String == guest.userId {
						activeMarker.position = coordinate
					}
				}
			} else {
				self.allGuestMarkers.append(marker)
				marker.map = self.mapView.myMapView

			}
			count += 1
		}
		self.allGuestMarkers = self.guestDistanceFromEvent(markers: self.allGuestMarkers)
		if self.allGuestMarkers.count > self.guestCount {
			self.setupMapBounds()
			self.guestCount = self.allGuestMarkers.count
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
		allOutOfRangeGuests.removeAll()
		//if guests are beyond proximity then alert
		for guest in allGuestMarkers {
			
			let guestDistance = distance(from: guest.position, to: hostEventMarker.position)
			guard let guestName = guest.title else {
				print("Unable to find guest's name!")
				return
			}
			
			if guestDistance > proximity {
				allOutOfRangeGuests.append((GuestName: guestName, GuestDistance: guestDistance))
				print("\((guestName)) is out of range by \(guestDistance) meters!")
			} else {
				print("\(String(describing: guest.title?.description)) is in range by \(guestDistance) meters!")
			}
			
		}
		if !allOutOfRangeGuests.isEmpty {
			var count = 0
			var alertMessage = String()
			for guest in allOutOfRangeGuests {
				let dist = (guest.GuestDistance*3.28084).rounded()
				alertMessage += "\(guest.GuestName) is \(Int(dist)) feet away"
				if count != allOutOfRangeGuests.count {
					alertMessage += "\n"
					count += 1
				}
			}
			
			let alertController = UIAlertController(title: "Oh no! Looks like some of your flock is lost!", message: alertMessage, preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
				self.proximityPassed = true
			}
			alertController.addAction(okAction)
			present(alertController, animated: true)
		}
		
	}
	func grouping() {
		var groupMarkers = [GMSMarker]()//or a dictionary of markers by grouping
		var markerGroupings = [GMSMarker:[InvitedModel]]()
		//if a guest is a certain distance from another guest group them, if guests are a certain distance from event group them
		
		for guest in allGuestMarkers {
			
			let guestDistance = distance(from: guest.position, to: hostEventMarker.position)
			guard let guestName = guest.title else {
				print("Unable to find guest's name!")
				return
			}
			
			if guestDistance > proximity {
				allOutOfRangeGuests.append((GuestName: guestName, GuestDistance: guestDistance))
				print("\((guestName)) is out of range by \(guestDistance) meters!")
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
			let bounds = GMSCoordinateBounds(coordinate: eventCoordinates, coordinate: guestCoordinate)
			mapView.myMapView.moveCamera(GMSCameraUpdate.fit(bounds, withPadding: 25))
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
		print("distance from update \(distanceFromUpdate)")
		usersCurrentLocation = currentLocation
	}
}
