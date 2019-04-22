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


class HomeViewController: BaseViewController {
    
    
    var homeView = HomeView()
    var filteredEvents = [Date](){
                didSet{
                    DispatchQueue.main.async {
                        self.homeView.usersCollectionView.reloadData()
                    }
                }
            }
    
    var events = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeView)
        view.backgroundColor = #colorLiteral(red: 0.995991528, green: 0.9961341023, blue: 0.9959602952, alpha: 1)
        homeView.usersCollectionView.dataSource = self
        homeView.usersCollectionView.delegate = self
//        navigationController?.navigationBar.topItem?.title = "Home"

        homeView.createButton.addTarget(self, action: #selector(showCreateEditEvent), for: .touchUpInside)
        //homeView.pastEventsButton.addTarget(self, action: #selector(showJoinEvent), for: .touchUpInside)
        fetchEvents()
        
        
        
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        homeView.usersCollectionView.reloadData()
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
    
    @objc func fetchEvents(){
        refreshControl.beginRefreshing()
        listener = DBService.firestoreDB
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
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventHomeCollectionViewCell", for: indexPath) as? EventHomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let eventToSet = events[indexPath.row]
        
        collectionViewCell.eventLabel.text = eventToSet.eventName
//        print(eventToSet.startDate)
        collectionViewCell.startDateLabel.text = eventToSet.startDate
        collectionViewCell.eventImage.kf.setImage(with: URL(string: eventToSet.imageURL ?? "no image available"), placeholder: #imageLiteral(resourceName: "pitons"))
        collectionViewCell.eventImage.alpha = 0.8
        return collectionViewCell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = EventViewController()
        let event = events[indexPath.row]
        detailVC.event = event
        let detailNav = UINavigationController.init(rootViewController: detailVC)

        present(detailNav, animated: true)
    }
    
    
}

extension HomeViewController: UserEventCollectionViewDelegate {
    func cancelPressed() {
        
    }
    
    func segmentedUserEventsPressed() {
        
    }
    
    func segmentedPastEventPressed() {
//       let date = Date()
//        let calendar = Calendar.current
//        let hours = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//
        
//        var filteredDate = events.filter {
//            $0.endDate < Date().
//        }
        }
        
    }
    
    func cancelPressed() {
        
    }
    
    private func fetchPastEvents(){
        
    }
    
    

