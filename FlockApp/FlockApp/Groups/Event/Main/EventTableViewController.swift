//
//  EventTableViewController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/22/19.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMaps
import Kingfisher
import MapKit
import UserNotifications

class EventTableViewController: UITableViewController {
    var proximityCircleMarker = GMSCircle()
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    lazy var myTimer = Timer(timeInterval: 10.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)

    private var friends = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var invited = [InvitedModel](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private lazy var refreshControll: UIRefreshControl = {
        let rc = UIRefreshControl()
        tableView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchInvites), for: .valueChanged)
        return rc
    }()
    
    let cellId = "EventCell"
    
    
    let eventView = EventView()
    
    public var event: Event?
    public var tag: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = eventView.cancelButton
        navigationItem.rightBarButtonItem = eventView.directionsButton
        refresh()
        //fetchInvites()
        self.title = event?.eventName
        self.tableView.sectionHeaderHeight = 400
        self.tableView.register(EventPeopleTableViewCell.self, forCellReuseIdentifier: "personCell")
        if tag == 2 {
            eventView.mapButton.addTarget(self, action: #selector(mapPressedPending), for: .touchUpInside)
        } else if tag == 0 {
            eventView.mapButton.addTarget(self, action: #selector(mapPressed), for: .touchUpInside)
        } else if tag == 1 {
            eventView.mapButton.addTarget(self, action: #selector(mapPressedEnded), for: .touchUpInside)
            
        }
        //if !On The Fly then add target
        guard let unwrappedEvent = event else {return}
        
        if isQuickEvent(eventType: unwrappedEvent) {
            eventView.eventAddress.isHidden = true
            eventView.eventTracking.isHidden = true
            quickEventMap(unwrappedEvent: unwrappedEvent)
            proximityCircle()
        } else {
            standardEventMap(unwrappedEvent: unwrappedEvent)
        }
        setTableViewBackgroundGradient(sender: self, #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1), .white)
        if let event = event, event.trackingTime.date() > Date() {
            print("start date is > ")
            
        } else {
            print("start date is < ")
            startTimer()
        }
//        setTableViewBackgroundGradient(sender: self, #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1), .white)
    }
    func proximityCircle() {
        guard let unwrappedEvent = event else {
            print("Unable to obtain event for proximity circle")
            return}
        let prox = unwrappedEvent.proximity
        print("Event Proximity is \(prox)")
        let circleCenter = CLLocationCoordinate2D(latitude: unwrappedEvent.locationLat, longitude: unwrappedEvent.locationLong)
        proximityCircleMarker = GMSCircle(position: circleCenter, radius: prox)

        proximityCircleMarker.fillColor = UIColor.init(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5)
        proximityCircleMarker.map = self.eventView.myMapView
        let stopMarker = GMSMarker.init(position: circleCenter)
        stopMarker.snippet = proximityCircleMarker.title
        stopMarker.opacity = 0
        stopMarker.map = self.eventView.myMapView
    }

    func standardEventMap(unwrappedEvent: Event) {
        let eventLat = unwrappedEvent.locationLat
        let eventLong = unwrappedEvent.locationLong
        let eventName = unwrappedEvent.eventName
        let eventAddress = unwrappedEvent.locationString
        let trackingTime = unwrappedEvent.trackingTime.formatISODateString(dateFormat: "MMM d, h:mm a")
        let startDate = unwrappedEvent.startDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        let endDate = unwrappedEvent.endDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        eventView.eventDate.text = "\(startDate) to \(endDate)"
        eventView.eventTracking.text = "Tracking begins: \(trackingTime)"
        eventView.eventAddress.text = eventAddress
        eventView.delegate = self
        eventView.myMapView.animate(to: GMSCameraPosition(latitude: eventLat, longitude: eventLong, zoom: 5))
        
        
        guard let markerImage = UIImage(named: "birdhouse") else {return}

        let marker = GMSMarker.init()
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: markerImage, borderColor: UIColor.darkGray, tag: 0)

        marker.position = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
        marker.title = eventName
        marker.map = eventView.myMapView
        marker.iconView = customMarker
        let position = marker.position
        let camera = GMSCameraPosition(latitude: position.latitude, longitude: position.longitude, zoom: 12.0)
        //THIS LINE IS WHAT CENTERS THE MARKER.
        eventView.myMapView.camera = camera
    }
    func quickEventMap(unwrappedEvent: Event){
        let eventLat = unwrappedEvent.locationLat
        let eventLong = unwrappedEvent.locationLong
        let eventName = unwrappedEvent.eventName
        let startDate = unwrappedEvent.startDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        let endDate = unwrappedEvent.endDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        eventView.eventDate.text = "\(startDate) to \(endDate)"
        eventView.eventAddress.text = "Starting Location"
        eventView.delegate = self
        eventView.myMapView.animate(to: GMSCameraPosition(latitude: eventLat, longitude: eventLong, zoom: 15))
        guard let markerImage = UIImage(named: "birdhouse") else {return}

        let marker = GMSMarker.init()
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: markerImage, borderColor: UIColor.darkGray, tag: 0)
        
        marker.position = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
        marker.title = eventName
        marker.map = eventView.myMapView
        marker.iconView = customMarker
        let position = marker.position
        let camera = GMSCameraPosition(latitude: position.latitude, longitude: position.longitude, zoom: 18)
        //THIS LINE IS WHAT CENTERS THE MARKER.
        eventView.myMapView.camera = camera
        setTableViewBackgroundGradient(sender: self, #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1), .white)

        
    }
    func isQuickEvent(eventType: Event) -> Bool {
        if eventType.eventName == "On The Fly" || eventType.eventName == "Quick Event"{
            return true
        } else {
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1).withAlphaComponent(0.2)
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailVC = EventPeopleViewController()
        let person = invited[indexPath.row]
        let eventToPass = event
        detailVC.event = eventToPass
        detailVC.personToSet = person
        if let _ = invited[indexPath.row].latitude, let _ = invited[indexPath.row].longitude {
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            showAlert(title: "Not Available", message: "User hasn't shared their location yet!")
            return
        }
    }
    
    
    func setTableViewBackgroundGradient(sender: UITableViewController, _ topColor:UIColor, _ bottomColor:UIColor) {
        
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = sender.tableView.bounds
        let backgroundView = UIView(frame: sender.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        sender.tableView.backgroundView = backgroundView
    }
    
    
    
    @objc func fetchInvites() {
        guard let event = event else {
            print("event is nil")
            return
        }
        
        DBService.firestoreDB
            .collection(EventsCollectionKeys.CollectionKey)
            .document(event.documentId)
            .collection(InvitedCollectionKeys.CollectionKey)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("failed to fetch invites: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    self.invited = snapshot.documents.map{InvitedModel(dict: $0.data()) }
                        .sorted { $0.displayName > $1.displayName}
                    for i in self.invited {
                        if i.confirmation {
                            print("\(event.startDate)-\(i.displayName): \(i.confirmation)")
                        }
                    }
                }
        }
    }
    

    
    func startTimer() {
        RunLoop.main.add(myTimer, forMode: RunLoop.Mode.default)
    }
    @objc func refresh() {
        fetchInvites()
        if let endDate = event?.endDate.date(), endDate < Date() {
            //invalidate timer
            myTimer.invalidate()
        }
        
        
    }
    @objc func mapPressed() {
            print("map pressed")
            let detailVC = MapViewController()
            detailVC.event = event
            detailVC.guests = self.invited
            navigationController?.pushViewController(detailVC, animated: true)
        }
    @objc func mapPressedPending() {
        print("map pressed while pending")
        let alertController = UIAlertController(title: "This map contains event guest current locations. Please confirm attendance to obtain access.", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
            
        })
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    @objc func mapPressedEnded() {
        print("map pressed while pending")
        let alertController = UIAlertController(title: "This event has ended. Unable to view guest locations at this time.", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
            
        })
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    @objc func getDirections() {
        guard let eventLat = self.event?.locationLat,
            let eventLong = self.event?.locationLong else {return}
        let coordinate = CLLocationCoordinate2DMake(eventLat,eventLong)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = self.event?.eventName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return eventView
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return invited.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        let person = invited[indexPath.row]
        cell.profilePicture.kf.setImage(with: URL(string: person.photoURL ?? "no photo"), placeholder: #imageLiteral(resourceName: "ProfileImage.png"))
        cell.nameLabel.text = person.displayName
        cell.taskLabel.text = person.task
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        cell.layer.cornerRadius = 50

        return cell
    }
    
}

extension EventTableViewController: EventViewDelegate {
    func cancelPressed() {
        dismiss(animated: true)
    }
}
