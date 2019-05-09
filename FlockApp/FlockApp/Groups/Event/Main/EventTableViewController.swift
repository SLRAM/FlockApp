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

class EventTableViewController: UITableViewController {
    
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
    
    let cellId = "EventCell"
    
    
    let eventView = EventView()
    
    private var listener: ListenerRegistration!
    
    public var event: Event?
    public var tag: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        navigationItem.leftBarButtonItem = eventView.cancelButton
        navigationItem.rightBarButtonItem = eventView.directionsButton
        fetchInvites()
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
        //if !quick event then add target
        guard let unwrappedEvent = event else {return}
        
        if isQuickEvent(eventType: unwrappedEvent) {
            quickEventMap(unwrappedEvent: unwrappedEvent)
        } else {
            standardEventMap(unwrappedEvent: unwrappedEvent)
        }
        
//        setTableViewBackgroundGradient(sender: self, #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1), .white)
    }
    func standardEventMap(unwrappedEvent: Event) {
        //        eventView.mapButton.addTarget(self, action: #selector(mapPressed), for: .touchUpInside)
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
        eventView.myMapView.animate(to: GMSCameraPosition(latitude: eventLat, longitude: eventLong, zoom: 15))
        let marker = GMSMarker.init()
        marker.position = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
        marker.icon = UIImage(named: "birdhouse")
        marker.title = eventName
        marker.map = eventView.myMapView
        let position = marker.position
        let camera = GMSCameraPosition(latitude: position.latitude, longitude: position.longitude, zoom: 12.0)
        //THIS LINE IS WHAT CENTERS THE MARKER.
        eventView.myMapView.camera = camera
    }
    func quickEventMap(unwrappedEvent: Event){
        //        eventView.mapButton.addTarget(self, action: #selector(mapPressed), for: .touchUpInside)
        let eventLat = unwrappedEvent.locationLat
        let eventLong = unwrappedEvent.locationLong
        let eventName = unwrappedEvent.eventName
        let startDate = unwrappedEvent.startDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        let endDate = unwrappedEvent.endDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        eventView.eventDate.text = "\(startDate) to \(endDate)"
        eventView.eventAddress.text = "Starting Location"
        eventView.delegate = self
        eventView.myMapView.animate(to: GMSCameraPosition(latitude: eventLat, longitude: eventLong, zoom: 15))
        let marker = GMSMarker.init()
        marker.position = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
        marker.title = eventName
        marker.map = eventView.myMapView
        let position = marker.position
        let camera = GMSCameraPosition(latitude: position.latitude, longitude: position.longitude, zoom: 18)
        //THIS LINE IS WHAT CENTERS THE MARKER.
        eventView.myMapView.camera = camera
        setTableViewBackgroundGradient(sender: self, #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1), .white)

        
    }
    func isQuickEvent(eventType: Event) -> Bool {
        if eventType.eventName == "Quick Event" {
            return true
        } else {
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = EventPeopleViewController()
        present(detailVC, animated: true, completion: nil)
        let person = invited[indexPath.row]
        detailVC.personToSet = person
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
    
    func fetchInvites() {
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
                }
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
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return invited.count
    }
    //
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Who's Invited"
    //    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        
        let person = invited[indexPath.row]
        cell.profilePicture.kf.setImage(with: URL(string: person.photoURL ?? "no photo"), placeholder: #imageLiteral(resourceName: "ProfileImage.png"))
        cell.nameLabel.text = person.displayName
        cell.taskLabel.text = person.task
        
        //cell borders
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        cell.layer.cornerRadius = 50
        //        cell.layer.borderWidth = 1
        
        
        //        cell.textLabel?.text = person.displayName
        //        cell.detailTextLabel?.text = person.task
        //        cell.imageView?.kf.setImage(with: URL(string: person.photoURL!))
        //        cell.imageView?.layer.borderWidth = 1
        //        cell.imageView?.layer.masksToBounds = false
        //        cell.imageView?.layer.cornerRadius = cell.imageView?.image.frame.height/2
        //        cell.imageView?.clipsToBounds = true
        return cell
    }
    
}

extension EventTableViewController: EventViewDelegate {
    func cancelPressed() {
        dismiss(animated: true)
    }
}
