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


class HomeViewController: UIViewController {
    
    
    var homeView = HomeView()
    
    var currentDate = Date.getISOTimestamp()
    
    var newUser = false
    
    
    var events = [Event]() {
        didSet {
            DispatchQueue.main.async {
//                self.filteredEvents = self.events
                self.segmentedEventsPressed()
                self.segmentedUserEventsPressed()
//                print(self.events)
                
            }
            
        }
    }
    
    var filteredEvents  = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.homeView.usersCollectionView.reloadData()
                self.segmentedUserEventsPressed()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeView)
        view.backgroundColor = #colorLiteral(red: 0.995991528, green: 0.9961341023, blue: 0.9959602952, alpha: 1)
        homeView.usersCollectionView.dataSource = self
        homeView.usersCollectionView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateEditEvent))
        title = "Home"
        
        fetchEvents()
        homeView.delegate = self
        homeView.dateLabel.text = currentDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        homeView.dayLabel.text = currentDate.formatISODateString(dateFormat: "EEEE")
        
        
        
    }
    
    
    
    @objc func showCreateEditEvent() {
        let createEditVC = CreateEditViewController()
        let createNav = UINavigationController.init(rootViewController: createEditVC)
        present(createNav, animated: true)
    }
    @objc func showJoinEvent(){
        let joinVC = JoinViewController()
        joinVC.modalPresentationStyle = .overFullScreen
        present (joinVC, animated: true)
    }
    
    private var listener: ListenerRegistration!
    private var authService = AppDelegate.authservice
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        homeView.usersCollectionView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchEvents), for: .valueChanged)
        return rc
    }()
    
//    @objc func fetchEvents(){
//        refreshControl.beginRefreshing()
//        listener = DBService.firestoreDB
//            .collection(EventsCollectionKeys.CollectionKey)
//            .addSnapshotListener({ [weak self] (snapshot, error) in
//                if let error = error {
//                    print("failed to fetch events with error: \(error.localizedDescription)")
//                } else if let snapshot = snapshot{
//                    self?.events = snapshot.documents.map{Event(dict: $0.data()) }
//                        .sorted { $0.createdDate.date() > $1.createdDate.date()}
//
//                }
//                DispatchQueue.main.async {
//                    self?.refreshControl.endRefreshing()
//                }
//            })
//    }
    
//    use this for filtering
    
    @objc func fetchEvents(){
        guard let user = authService.getCurrentUser() else {
            print("no logged user")
            return
        }
        refreshControl.beginRefreshing()
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(EventsCollectionKeys.CollectionKey)
            .addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch events with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot{
                    self?.events = snapshot.documents.map{Event(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date()}
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            })
    }
    //use this for filtering
    //    @objc func fetchUserEvents(){
    //        guard let user = authService.getCurrentUser() else {
    //            print("no logged user")
    //            return
    //        }
    //        refreshControl.beginRefreshing()
    //        listener = DBService.firestoreDB
    //            .collection(UsersCollectionKeys.CollectionKey)
    //            .document(user.uid)
    //            .collection(EventsCollectionKeys.CollectionKey)
    //            .addSnapshotListener({ [weak self] (snapshot, error) in
    //                if let error = error {
    //                    print("failed to fetch events with error: \(error.localizedDescription)")
    //                } else if let snapshot = snapshot{
    //                    self?.events = snapshot.documents.map{Event(dict: $0.data()) }
    //                        .sorted { $0.createdDate.date() > $1.createdDate.date()}
    //                }
    //                DispatchQueue.main.async {
    //                    self?.refreshControl.endRefreshing()
    //                }
    //            })
    //    }
    
    
    
    
    
    //    func fetchHomeState() {
    //        refreshControl.beginRefreshing()
    //        listener = DBService.firestoreDB
    //        .collection(EventsCollectionKeys.CollectionKey)
    //            .addSnapshotListener({ [weak self] ( createEvent, error ) in
    //                if let error = error {
    //                    print("failed to fetch home state: \(error.localizedDescription)")
    //                } else if let createEvent = createEvent {
    //
    //                }
    //            })
    //        if newUser == false {
    //            guard let user = authService.getCurrentUser() else {
    //                print("no user")
    //                return
    //            }
    //        homeView.delegate = self
    //            DBService.fetchUser(userId: user.uid) { (error, user) in
    //
    //            }
    //
    //        }
    //    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredEvents.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventHomeCollectionViewCell", for: indexPath) as? EventHomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let eventToSet = filteredEvents[indexPath.row]
        collectionViewCell.eventLabel.text = eventToSet.eventName
        let startDate = eventToSet.startDate
        collectionViewCell.startDateLabel.text = startDate
        collectionViewCell.startDateLabel.text = eventToSet.startDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        collectionViewCell.eventImage.kf.setImage(with: URL(string: eventToSet.imageURL ?? "no image available"), placeholder: #imageLiteral(resourceName: "pitons"))
        //collectionViewCell.layer.cornerRadius = 14
        collectionViewCell.eventImage.alpha = 0.8
        return collectionViewCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = EventTableViewController()
        let event = filteredEvents[indexPath.row]
        detailVC.event = event
        let detailNav = UINavigationController.init(rootViewController: detailVC)
        
        present(detailNav, animated: true)
    }
    
    
}

extension HomeViewController: UserEventCollectionViewDelegate {
    func segmentedEventsPressed() {
        
    }
    
    func pendingJoinEventPressed() {
        
    }
    
    func segmentedUserEventsPressed() {
        let formatter = ISO8601DateFormatter()
        guard let pastEvent = formatter.date(from: self.currentDate) else { return }
        
        filteredEvents = events.filter {
//            let eventDate = $0.endDate.date()
//
//            return eventDate > pastEvent
            
            $0.endDate.date() > pastEvent
            
        }
        
    }
    
    func segmentedPastEventPressed() {
        let formatter = ISO8601DateFormatter()
        guard let currentDate = formatter.date(from: self.currentDate) else { return }
        filteredEvents =  events.filter {
            $0.endDate.date() < currentDate
        }
    }
    
    func joinEventPressed(){
        
    }
    
    func newUserView() {
        
    }
    
    
    
}
