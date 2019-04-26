//
//  QuickEventViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/25/19.
//

import UIKit
import GoogleMaps
import MapKit
import Firebase
import Toucan

class QuickEventViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var usersCurrentLocation = CLLocation()
    
    private let quickEventView = QuickEventView()
    let trackingPlaceholder = "Event Tracking Time"
    let proximityPlaceholder = "Proximity Distance"

    var friendsArray = [UserModel]()
    var friendsDictionary : Dictionary<Int,String> = [:]
    var selectedCoordinates = CLLocationCoordinate2D()


    var trackingTime = 0
    var hours = 0
    
    var proximity = 0
    var distance = 0

    let quickImage = UIImage(named: "pitons")
    var selectedImage : UIImage?
    
    private var authservice = AppDelegate.authservice


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.view.addSubview(quickEventView)
        selectedImage = Toucan.init(image: quickImage!).resize(CGSize(width: 500, height: 500)).image
        quickEventView.delegate = self
        quickEventView.myTableView.delegate = self
        quickEventView.myTableView.dataSource = self
        navigationItem.rightBarButtonItem = quickEventView.createButton
        navigationItem.leftBarButtonItem = quickEventView.cancelButton
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

        
    }
    
    func editNumber(increase: Bool)-> String {
        if hours != 0 && increase == false{
            hours -= 1
        } else if increase == true {
            hours += 1
        }
        if hours == 1{
            return "End event in \(hours) hour"
        } else if hours == 0{
            return trackingPlaceholder
        } else {
            return "End event in \(hours) hours"
        }
    }
    func editProximity(increase: Bool)-> String {
        if distance != 0 && increase == false{
            distance -= 10
        } else if increase == true {
            distance += 10
        }
        if distance == 0{
            return proximityPlaceholder
        } else {
            return "\(distance) feet from Host"
        }
    }

}
extension QuickEventViewController: QuickEventViewDelegate {
    
    
    
    
    
    
    
    func quickTrackingDecrease() {
        let trackingLabel = editNumber(increase: false)
        quickEventView.myLabel.text = trackingLabel
        trackingTime -= 1
    }
    
    func quickTrackingIncrease() {
        let trackingLabel = editNumber(increase: true)
        quickEventView.myLabel.text = trackingLabel
        trackingTime += 1
    }
    
    func cancelQuickPressed() {
        dismiss(animated: true)
    }
    
    func createQuickPressed() {
        
        var eventLength = hours*60
        var currentDate = Date()
        var endingDate = currentDate.adding(minutes: eventLength)

        let isoDateFormatter = ISO8601DateFormatter()
        let startingString = isoDateFormatter.string(from: currentDate)
        let endingString = isoDateFormatter.string(from: endingDate)
        
        let eventName = "Quick Event"
        var friendIds = [String]()
        for friends in friendsArray {
            friendIds.append(friends.userId)
        }
        
        guard let user = authservice.getCurrentUser() else {
            let alertController = UIAlertController(title: "Unable to post. Please login to post.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            return}
        
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0) else {
            let alertController = UIAlertController(title: "Unable to post. Please fill in the required fields.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return}
        
        
        let docRef = DBService.firestoreDB
            .collection(EventsCollectionKeys.CollectionKey)
            .document()
        StorageService.postImage(imageData: imageData, imageName: Constants.EventImagePath + "\(user.uid)/\(docRef.documentID)") { [weak self] (error, imageURL) in
            if let error = error {
                print("failed to post image with error: \(error.localizedDescription)")
            } else if let imageURL = imageURL {
                print("image posted and recieved imageURL - post blog to database: \(imageURL)")
                let event = Event(eventName: eventName,
                                  createdDate: Date.getISOTimestamp(),
                                  userID: user.uid,
                                  imageURL: imageURL.absoluteString,
                                  eventDescription: nil,
                                  documentId: docRef.documentID,
                                  startDate: startingString,
                                  endDate: endingString,
                                  locationString: nil,
                                  locationLat: self!.usersCurrentLocation.coordinate.latitude,
                                  locationLong: self!.usersCurrentLocation.coordinate.longitude,
                                  trackingTime: 0,
                                  quickEvent: true,
                                  proximity: 0) //set value for proximity!
                DBService.postEvent(event: event, completion: { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: "Posting Event Error", message: error.localizedDescription)
                    } else {
                        //create function that goes through friends array
                        //function that takes array and turns to dictionary
                        DBService.addInvited(user: user, docRef: docRef.documentID, friends: self!.friendsArray, tasks: self!.friendsDictionary, completion: { [weak self] error in
                            if let error = error {
                                self?.showAlert(title: "Inviting Friends Error", message: error.localizedDescription)
                            } else {
                                self?.showAlert(title: "Event Posted", message: nil) { action in
                                    print(docRef.documentID)
                                    let detailVC = EventViewController()
                                    detailVC.event = event
                                    //                    detailVC.delegate = self
                                    self?.navigationController?.pushViewController(detailVC, animated: true)
                                }
                            }
                        })
                    }
                })
            }
        }
        
    }
    
    func friendsQuickPressed() {
        let detailVC = InvitedViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func quickProximityIncrease() {
        let proximityLabel = editProximity(increase: true)
        quickEventView.myProximityLabel.text = proximityLabel
        proximity += 10
    }
    
    func quickProximityDecrease() {
        let trackingLabel = editProximity(increase: false)
        quickEventView.myProximityLabel.text = trackingLabel
        proximity -= 10
    }
    
}
extension QuickEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = quickEventView.myTableView.dequeueReusableCell(withIdentifier: "CreateEditTableViewCell", for: indexPath) as? CreateEditTableViewCell else {return UITableViewCell()}
        let friend = friendsArray[indexPath.row]
        cell.selectionStyle = .none
        cell.friendTask.alpha = 0
        cell.friendName.text = friend.displayName
        return cell
    }
    
}
extension QuickEventViewController: InvitedViewControllerDelegate {
    func selectedFriends(friends: [UserModel]) {
        friendsArray = friends
        var count = 0
        for friend in friends {
            friendsDictionary[count] = "No Task"
        }
        quickEventView.myTableView.reloadData()
    }
    
}
extension QuickEventViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("user changed the authorization")

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this kicks off whenever the user's location has noticeably changed
        guard let currentLocation = locations.last else {return}
        usersCurrentLocation = currentLocation
    }
}
