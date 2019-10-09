//
//  QuickEventTableViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 9/3/19.
//

import UIKit
import MapKit
import GoogleMaps
import Firebase
import Toucan
import UserNotifications
import Kingfisher


class QuickEventTableViewController: UITableViewController {
    let quickEventTableView = QuickEventTableView()
    public var event: Event?
    public var tag: Int?
    
    let trackingPlaceholder = "Event Tracking Time"
    let proximityPlaceholder = "Proximity Distance"
    let quickImage = UIImage(named: "quickEvent")
    
    let locationManager = CLLocationManager()
    var usersCurrentLocation = CLLocation()
    var friendsArray = [UserModel]()
    var friendsDictionary : Dictionary<Int,String> = [:]
    var selectedCoordinates = CLLocationCoordinate2D()
    private var authservice = AppDelegate.authservice
    var selectedImage : UIImage?
    
    var trackingTime = 0
    var hours = 0
    var proximity = 0
    var distance = 0
    var isTextField = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9665842652, green: 0.9562553763, blue: 0.9781278968, alpha: 1)
        navigationItem.leftBarButtonItem = quickEventTableView.cancelButton
        let frameSection = view.frame.height/4.5
        self.tableView.sectionHeaderHeight = frameSection
        self.tableView.register(EventPeopleTableViewCell.self, forCellReuseIdentifier: "personCell")
        viewSetup()
    }
    
    func viewSetup() {
        navigationItem.title = "Create On The Fly"
        selectedImage = Toucan.init(image: quickImage!).resize(CGSize(width: 500, height: 500)).image
        navigationItem.rightBarButtonItem = quickEventTableView.createButton
        navigationItem.leftBarButtonItem = quickEventTableView.cancelButton
        locationManager.delegate = self
        quickEventTableView.delegate = self
        mapAuth()
    }
    func mapAuth() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
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
            distance -= 50
        } else if increase == true {
            distance += 50
        }
        if distance == 0{
            return proximityPlaceholder
        } else {
            return "\(distance) feet from Host"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1).withAlphaComponent(0.2)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return quickEventTableView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        let person = friendsArray[indexPath.row]
        cell.layer.cornerRadius = 50
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.profilePicture.kf.setImage(with: URL(string: person.photoURL ?? "no photo"), placeholder: #imageLiteral(resourceName: "ProfileImage.png"))
        cell.nameLabel.text = person.displayName
        cell.taskField.tag = indexPath.row
        cell.taskField.isHidden = true
        return cell
    }
    
}
extension QuickEventTableViewController: QuickEventTableViewDelegate {
    
    func quickTrackingDecrease() {
        let trackingLabel = editNumber(increase: false)
        quickEventTableView.myLabel.text = trackingLabel
        trackingTime -= 1
    }
    
    func quickTrackingIncrease() {
        let trackingLabel = editNumber(increase: true)
        quickEventTableView.myLabel.text = trackingLabel
        trackingTime += 1
    }
    
    func cancelQuickPressed() {
        dismiss(animated: true)
    }
    
    func createQuickPressed() {
        quickEventTableView.createButton.isEnabled = false
        let eventLength = hours*60
        let currentDate = Date()
        let endingDate = currentDate.adding(minutes: eventLength)
        
        let isoDateFormatter = ISO8601DateFormatter()
        let startingString = isoDateFormatter.string(from: currentDate)
        let endingString = isoDateFormatter.string(from: endingDate)
        
        let eventName = "On The Fly"
        var friendIds = [String]()
        for friends in friendsArray {
            friendIds.append(friends.userId)
        }
        
        guard let user = authservice.getCurrentUser() else {
            let alertController = UIAlertController(title: "Unable to post. Please login to post.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.quickEventTableView.createButton.isEnabled = true
            }
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            return}
        
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0) else {
            let alertController = UIAlertController(title: "Unable to post. Please fill in the required fields.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.quickEventTableView.createButton.isEnabled = true
            }
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
                                  trackingTime: startingString,
                                  quickEvent: true,
                                  proximity: Double(self!.distance)/3.28084) //set value for proximity!
                DBService.postEvent(event: event, completion: { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: "Posting Event Error", message: error.localizedDescription)
                    } else {
                        //create function that goes through friends array
                        //function that takes array and turns to dictionary
                        DBService.postPendingEventToUser(user: user, userIds: self!.friendsArray, event: event, completion: { [weak self] error in
                            if let error = error {
                                self?.showAlert(title: "Posting Event To Guest Pending Error", message: error.localizedDescription)
                            } else {
                                print("posted to guest pending")
                            }
                        })
                        DBService.postAcceptedEventToUser(user: user, event: event, completion: { [weak self] error in
                            if let error = error {
                                self?.showAlert(title: "Posting Event To Host Accepted Error", message: error.localizedDescription)
                            } else {
                                print("posted to host accepted")
                            }
                        })
                        
                        DBService.addInvited(user: user, docRef: docRef.documentID, friends: self!.friendsArray, tasks: self!.friendsDictionary, completion: { [weak self] error in
                            if let error = error {
                                self?.showAlert(title: "Inviting Friends Error", message: error.localizedDescription)
                            } else {
                                //============================================================
                                // Adding notification
                                //                                let startContent = UNMutableNotificationContent()
                                //
                                //                                startContent.title = NSString.localizedUserNotificationString(forKey: "\(event.eventName) Beginning", arguments: nil)
                                //                                startContent.body = NSString.localizedUserNotificationString(forKey: "\(event.eventName) Starting", arguments: nil)
                                //                                startContent.sound = UNNotificationSound.default
                                //
                                //                                let endContent = UNMutableNotificationContent()
                                //                                endContent.title = NSString.localizedUserNotificationString(forKey: "\(event.eventName) ended", arguments: nil)
                                //                                endContent.body = NSString.localizedUserNotificationString(forKey: "\(event.eventName) Ending", arguments: nil)
                                //                                endContent.sound = UNNotificationSound.default
                                //                                let startDate = self?.selectedStartDate
                                //                                let calendar = Calendar.current
                                //                                let startHour = calendar.component(.hour, from: startDate!)
                                //                                let startMinutes = calendar.component(.minute, from: startDate!)
                                //
                                //                                let endDate = self?.selectedEndDate
                                //                                let endHour = calendar.component(.hour, from: endDate!)
                                //                                let endMinutes = calendar.component(.minute, from: endDate!)
                                //
                                //                                var startDateComponent = DateComponents()
                                //                                startDateComponent.hour = startHour
                                //                                startDateComponent.minute = startMinutes
                                //                                startDateComponent.timeZone = TimeZone.current
                                //                                var endDateComponent = DateComponents()
                                //                                endDateComponent.hour = endHour
                                //                                endDateComponent.minute = endMinutes
                                //                                endDateComponent.timeZone = TimeZone.current
                                //
                                //                                let startTrigger = UNCalendarNotificationTrigger(dateMatching: startDateComponent, repeats: false)
                                //                                let endTrigger = UNCalendarNotificationTrigger(dateMatching: endDateComponent, repeats: false)
                                //
                                //                                let startRequest = UNNotificationRequest(identifier: "Event Start", content: startContent, trigger: startTrigger)
                                //                                let endRequest = UNNotificationRequest(identifier: "Event End", content: endContent, trigger: endTrigger)
                                //
                                //                                UNUserNotificationCenter.current().add(startRequest) { (error) in
                                //                                    if let error = error {
                                //                                        print("notification delivery error: \(error)")
                                //                                    } else {
                                //                                        print("successfully added start notification")
                                //                                    }
                                //                                }
                                //                                UNUserNotificationCenter.current().add(endRequest) { (error) in
                                //                                    if let error = error {
                                //                                        print("notification delivery error: \(error)")
                                //                                    } else {
                                //                                        print("successfully added end notification")
                                //                                    }
                                //                                }
                                self?.showAlert(title: "Event Posted", message: nil) { action in
                                    print(docRef.documentID)
                                    //                    self?.dismiss(animated: true)//code here to segue to detail
                                    let detailVC = EventTableViewController()
                                    detailVC.event = event
                                    detailVC.tag = 0
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
        quickEventTableView.myProximityLabel.text = proximityLabel
        //        proximity += 30
    }
    
    func quickProximityDecrease() {
        let trackingLabel = editProximity(increase: false)
        quickEventTableView.myProximityLabel.text = trackingLabel
    }
    
}

extension QuickEventTableViewController: InvitedViewControllerDelegate {
    func selectedFriends(friends: [UserModel]) {
        print("Friends selected")
        friendsArray = friends
        var count = 0
        for _ in friends {
            if friendsDictionary[count] == nil {
                friendsDictionary[count] = "No Task"
            }
            count += 1
        }
        tableView.reloadData()
    }
}
extension QuickEventTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField")
        isTextField = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //for id key save text
        guard let typedText = textField.text else {return false}
        for (key, _) in friendsDictionary {
            
            if textField.tag == key {
                friendsDictionary[key] = typedText
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        isTextField = false
        //for id key save text
        guard let typedText = textField.text else {
            print("unable to obtain task")
            return
        }
        for (key, _) in friendsDictionary {
            
            if textField.tag == key {
                friendsDictionary[key] = typedText
            }
        }
    }
}

extension QuickEventTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("user changed the authorization")
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this kicks off whenever the user's location has noticeably changed
        guard let currentLocation = locations.last else {return}
        usersCurrentLocation = currentLocation
    }
}
