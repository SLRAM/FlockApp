//
//  HomeViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseFirestore
import UserNotifications


class HomeViewController: UIViewController {
    
    let color = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
    var homeView = HomeView()
    var emptyState = EmptyStateView()
    var currentDate = Date.getISOTimestamp()
    var newUser = false
    private var pendingEventListener: ListenerRegistration!
    private var acceptedEventListener: ListenerRegistration!
    private var authService = AppDelegate.authservice
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        homeView.usersCollectionView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchEvents), for: .valueChanged)
        return rc
    }()
    
    var pendingEvents = [Event]()
    var acceptedEvents = [Event]()

    var tag = 0
    
    var filteredAcceptedEvents  = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.homeView.usersCollectionView.reloadData()
                
            }
        }
    }
    
    var filteredPastEvents  = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.homeView.usersCollectionView.reloadData()
            }
        }
    }
    
    
    var filteredPendingEvents  = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.homeView.usersCollectionView.reloadData()
                if self.filteredPendingEvents.isEmpty {
                    self.homeView.notificationIndicator.isHidden = true
                } else {
                    self.homeView.notificationIndicator.isHidden = false
                }
            }
        }
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        if let _ = authService.getCurrentUser() {
//        
//        } else {
//            pendingEventListener = nil
//            acceptedEventListener = nil
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = color
        self.navigationController?.navigationBar.barTintColor = color
        view.addSubview(homeView)
        setupView()
//        view.addSubview(emptyState)
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9568627451, blue: 0.9764705882, alpha: 1)
        fetchEvents()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateEditEvent))
        title = "Flock"
        homeView.segmentedControl.selectedSegmentIndex = 0
        

        homeView.delegate = self

        homeView.dateLabel.text = currentDate.formatISODateString(dateFormat: "MMM d, yyyy")
        homeView.dayLabel.text = currentDate.formatISODateString(dateFormat: "EEEE")
       
        
        homeView.segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        
        indexChanged(homeView.segmentedControl)
        
        //Swipe gesture code//
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender: )))
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe(sender: )))
        
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        
        self.homeView.addGestureRecognizer(rightSwipe)
        self.homeView.addGestureRecognizer(leftSwipe)
        
      

    }
    func setupView() {
        if filteredAcceptedEvents.isEmpty {

//            homeView.usersCollectionView.backgroundView = emptyState
            //make empty state visible
        } else {
            
        }

    }
    
    //Swipe gesture code//
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        switch sender.direction {
        case .left:
            print("Left")
            if self.homeView.segmentedControl.selectedSegmentIndex == 2 {
                self.homeView.segmentedControl.selectedSegmentIndex = 0
                self.homeView.segmentedControl.sendActions(for: .valueChanged)
            } else {
                self.homeView.segmentedControl.selectedSegmentIndex = self.homeView.segmentedControl.selectedSegmentIndex + 1
                self.homeView.segmentedControl.sendActions(for: .valueChanged)
            }
        case .right:
            print("right")
            if self.homeView.segmentedControl.selectedSegmentIndex == 0 {
                self.homeView.segmentedControl.selectedSegmentIndex = 2
                self.homeView.segmentedControl.sendActions(for: .valueChanged)
            } else {
                self.homeView.segmentedControl.selectedSegmentIndex = self.homeView.segmentedControl.selectedSegmentIndex - 1
                self.homeView.segmentedControl.sendActions(for: .valueChanged)
            }
        default:
            print("Nothing")
        }
    }
    

    func acceptEventPressed(eventCell: Event) {
        guard let user = authService.getCurrentUser() else {
            print("no logged user")
            return
        }
        DBService.postAcceptedEventToUser(user: user, event: eventCell, completion: { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Posting Event To Accepted Error", message: error.localizedDescription)
            } else {
                print("posted to accepted list")
                // Add notification of event here
                let startContent = UNMutableNotificationContent()
                let dateFormatter = ISO8601DateFormatter()
                startContent.title = NSString.localizedUserNotificationString(forKey: "\(eventCell.eventName) Beginning", arguments: nil)
                startContent.body = NSString.localizedUserNotificationString(forKey: "\(eventCell.eventName) Starting", arguments: nil)
                startContent.sound = UNNotificationSound.default
                
                let endContent = UNMutableNotificationContent()
                endContent.title = NSString.localizedUserNotificationString(forKey: "\(eventCell.eventName) ended", arguments: nil)
                endContent.body = NSString.localizedUserNotificationString(forKey: "\(eventCell.eventName) Ending", arguments: nil)
                endContent.sound = UNNotificationSound.default
                let startDate = dateFormatter.date(from: eventCell.startDate)
                let calendar = Calendar.current
                let startYear = calendar.component(.year, from: startDate!)
                let startMonth = calendar.component(.month, from: startDate!)
                let startDay = calendar.component(.day, from: startDate!)
                let startHour = calendar.component(.hour, from: startDate!)
                let startMinutes = calendar.component(.minute, from: startDate!)
                
                let endDate = dateFormatter.date(from: eventCell.endDate)
                let endYear = calendar.component(.year, from: endDate!)
                let endMonth = calendar.component(.month, from: endDate!)
                let endDay = calendar.component(.day, from: endDate!)
                let endHour = calendar.component(.hour, from: endDate!)
                let endMinutes = calendar.component(.minute, from: endDate!)
                
                var startDateComponent = DateComponents()
                startDateComponent.year = startYear
                startDateComponent.month = startMonth
                startDateComponent.day = startDay
                startDateComponent.hour = startHour
                startDateComponent.minute = startMinutes
                startDateComponent.timeZone = TimeZone.current
                var endDateComponent = DateComponents()
                endDateComponent.year = endYear
                endDateComponent.month = endMonth
                endDateComponent.day = endDay
                endDateComponent.hour = endHour
                endDateComponent.minute = endMinutes
                endDateComponent.timeZone = TimeZone.current
                
                let startTrigger = UNCalendarNotificationTrigger(dateMatching: startDateComponent, repeats: false)
                let endTrigger = UNCalendarNotificationTrigger(dateMatching: endDateComponent, repeats: false)
                
               

                let startRequest = UNNotificationRequest(identifier: "Event Start", content: startContent, trigger: startTrigger)
                let endRequest = UNNotificationRequest(identifier: "Event End", content: endContent, trigger: endTrigger)
                
                UNUserNotificationCenter.current().add(startRequest) { (error) in
                    if let error = error {
                        print("notification delivery error: \(error)")
                    } else {
                        print("successfully added start notification")
                    }
                }
                UNUserNotificationCenter.current().add(endRequest) { (error) in
                    if let error = error {
                        print("notification delivery error: \(error)")
                    } else {
                        print("successfully added end notification")
                    }
                }
                DBService.deleteEventFromPending(user: user, event: eventCell, completion: { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: "Deleting Event from Pending Error", message: error.localizedDescription)
                    } else {
                        print("Deleted Event from Pending list")
                        
                        let index = self?.filteredPendingEvents.firstIndex { $0.documentId == eventCell.documentId }
                        if let foundIndex = index {
                            self?.filteredPendingEvents.remove(at: foundIndex)
                        }
                        
                        //self?.homeView.usersCollectionView.reloadData()
                    }
                })
            }
        })
        homeView.usersCollectionView.reloadData()

    }
    
    
    @objc func showCreateEditEvent() {
        
        let optionMenu = UIAlertController(title: nil, message: "Create an Event:", preferredStyle: .actionSheet)
        let  eventAction = UIAlertAction(title: "Standard Event", style: .default, handler: { (action) -> Void in
            let createEditVC = CreateEditViewController()
            let createNav = UINavigationController.init(rootViewController: createEditVC)
            self.present(createNav, animated: true)
        })
        let  quickEventAction = UIAlertAction(title: "On The Fly", style: .default, handler: { (action) -> Void in
            
            let quickEditVC = QuickEventViewController()
            let createNav = UINavigationController.init(rootViewController: quickEditVC)
            self.present(createNav, animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(eventAction)
        optionMenu.addAction(quickEventAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)

  
    }
  
    
    @objc func indexChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("Current Events")
            tag = 0

            homeView.delegate?.segmentedEventsPressed()
            if filteredAcceptedEvents.isEmpty {
                homeView.usersCollectionView.backgroundView = emptyState
                emptyState.emptyStateLabel.text = "No current events available. Click the + to create your own!"
            } else {
                homeView.usersCollectionView.backgroundView = UIView()
            }
        case 1:
            print("Past Event")
            tag = 1

            homeView.delegate?.segmentedPastEventPressed()
            if filteredPastEvents.isEmpty {
                homeView.usersCollectionView.backgroundView = emptyState
                emptyState.emptyStateLabel.text = "No past events available. Once an accepted even expires, it will show up here."
            } else {
                homeView.usersCollectionView.backgroundView = UIView()
            }

        case 2:
            print("Join Event")
            tag = 2

            homeView.delegate?.pendingJoinEventPressed()
            if filteredPendingEvents.isEmpty {
                homeView.usersCollectionView.backgroundView = emptyState
                emptyState.emptyStateLabel.text = "No pending events available. Once a friend invites you to their event, it will show up here."
            } else {
                homeView.usersCollectionView.backgroundView = UIView()
            }

    
            
        default:
            break
        }
    }

    @objc func fetchEvents(){
        
        guard let user = authService.getCurrentUser() else {
            print("no logged user")
            return
        }
        
        refreshControl.beginRefreshing()
        pendingEventListener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(EventsCollectionKeys.EventPendingKey)
            .addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch events with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot{
                    
                    self?.pendingEvents = snapshot.documents.map{Event(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date()}
                    self?.pendingJoinEventPressed()
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            })
        
        
        acceptedEventListener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(EventsCollectionKeys.EventAcceptedKey)
            .addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch events with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot{
                    
                    
                    self?.acceptedEvents = snapshot.documents.map{Event(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date()}
                    
                }
                DispatchQueue.main.async {
                    self?.homeView.delegate?.segmentedEventsPressed()
                    self?.homeView.usersCollectionView.dataSource = self
                    self?.homeView.usersCollectionView.delegate = self
                    self?.refreshControl.endRefreshing()
                    
                }
            })
    }
    

}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch tag {
        case 0:
            return filteredAcceptedEvents.count
            
        case 1:
            return filteredPastEvents.count

        case 2:
            return filteredPendingEvents.count

        default:
            return 0
        }
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventHomeCollectionViewCell", for: indexPath) as? EventHomeCollectionViewCell else {
            return UICollectionViewCell()
            
        }
        
        collectionViewCell.contentView.layer.masksToBounds = true
        collectionViewCell.backgroundColor = .clear // very important
        collectionViewCell.layer.masksToBounds = false
        collectionViewCell.layer.shadowOpacity = 0.35
        collectionViewCell.layer.shadowRadius = 10
        collectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 0)
        collectionViewCell.layer.shadowColor = UIColor.black.cgColor
        
        let radius = collectionViewCell.contentView.layer.cornerRadius
        collectionViewCell.layer.shadowPath = UIBezierPath(roundedRect: collectionViewCell.bounds, cornerRadius: radius).cgPath


        
        var eventToSet = Event()
        let personToSet = InvitedModel()
        
        
        
        switch tag {
        case 0:
            eventToSet = filteredAcceptedEvents[indexPath.row]
            collectionViewCell.joinEventButton.isHidden = true
            collectionViewCell.goingButton.isHidden = true
            collectionViewCell.declineButton.isHidden = true
            collectionViewCell.eventLabel.isHidden = false
            collectionViewCell.startDateLabel.isHidden = false
            collectionViewCell.eventImage.alpha = 0.8
            collectionViewCell.invitedByLabel.isHidden = false
            collectionViewCell.friendThumbnail.isHidden = false
            

            
        case 1:
            eventToSet = filteredPastEvents[indexPath.row]
            collectionViewCell.joinEventButton.isHidden = true
            collectionViewCell.goingButton.isHidden = true
            collectionViewCell.declineButton.isHidden = true
            collectionViewCell.eventLabel.isHidden = false
            collectionViewCell.startDateLabel.isHidden = false
            collectionViewCell.eventImage.alpha = 0.8
            
        

            
        case 2:
            eventToSet = filteredPendingEvents[indexPath.row]
            collectionViewCell.joinEventButton.isHidden = false
            collectionViewCell.joinEventButton.isEnabled = true
            collectionViewCell.goingButton.isHidden = false
            collectionViewCell.declineButton.isHidden = false
            collectionViewCell.eventLabel.isHidden = false
            collectionViewCell.startDateLabel.isHidden = false
            
            
        default:
            print("tag's did not process correctly")
        }
        
        collectionViewCell.delegate = self
        collectionViewCell.goingButton.tag = indexPath.row
        collectionViewCell.declineButton.tag = indexPath.row
        collectionViewCell.eventLabel.text = eventToSet.eventName
        
        
        
        
        let startDate = eventToSet.startDate
        collectionViewCell.startDateLabel.text = startDate
        collectionViewCell.startDateLabel.text = eventToSet.startDate.formatISODateString(dateFormat: "EEEE, MMM d, yyyy, h:mm a")
        collectionViewCell.eventImage.kf.setImage(with: URL(string: eventToSet.imageURL ?? "no image available"))
        DBService.fetchUser(userId: eventToSet.userID) { (error, userModel) in
            if let error = error {
                print(error.localizedDescription)
            } else if let userModel = userModel {
                collectionViewCell.friendThumbnail.kf.setImage(with: URL(string: userModel.photoURL ?? "no image available"), placeholder: #imageLiteral(resourceName: "pitons"))
            }
        }
        
        return collectionViewCell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //when a user clicks on the cell's button call acceptEventPressed
        let detailVC = EventTableViewController()
        var event = Event()

        switch tag {
        case 0:
            event = filteredAcceptedEvents[indexPath.row]
            detailVC.tag = 0
            
            
        case 1:
            event = filteredPastEvents[indexPath.row]
            detailVC.tag = 1
            
            
        case 2:
            event = filteredPendingEvents[indexPath.row]
            detailVC.tag = 2
            
        default:
            print("you good fam")
        }
        detailVC.event = event
        let detailNav = UINavigationController.init(rootViewController: detailVC)
        
        present(detailNav, animated: true)
    }
    
}


extension HomeViewController: UserEventCollectionViewDelegate {
    
    func segmentedEventsPressed() {
        let formatter = ISO8601DateFormatter()
        guard let currentDate = formatter.date(from: self.currentDate) else { return }
        //this should be events that you've accepted
        filteredAcceptedEvents =  acceptedEvents.filter {
            $0.endDate.date() > currentDate
        }
    }
    
    func segmentedPastEventPressed() {
        let formatter = ISO8601DateFormatter()
        guard let currentDate = formatter.date(from: self.currentDate) else { return }
        filteredPastEvents =  acceptedEvents.filter {
            $0.endDate.date() < currentDate
        }
    }
    
    func pendingJoinEventPressed() {
        let formatter = ISO8601DateFormatter()
        guard let currentDate = formatter.date(from: self.currentDate) else { return }
        filteredPendingEvents =  pendingEvents.filter {
            $0.endDate.date() > currentDate
        }
    }
    
  
    
    
    
}
extension HomeViewController: EventHomeCollectionViewCellDelegate {
    func declinePressed(tag: Int) {
        print(tag)
        let event = filteredPendingEvents[tag]
        acceptEventPressed(eventCell: event)
    }

    func acceptedPressed(tag: Int) {
        print(tag)
        let event = filteredPendingEvents[tag]
        acceptEventPressed(eventCell: event)
    }



}
