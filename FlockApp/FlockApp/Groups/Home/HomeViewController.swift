//
//  HomeViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import Kingfisher
import Firebase


class HomeViewController: BaseViewController {
    
    var homeView = HomeView()
    var events = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.homeView.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flock"
        view.addSubview(homeView)
        view.backgroundColor = #colorLiteral(red: 0.995991528, green: 0.9961341023, blue: 0.9959602952, alpha: 1)
        homeView.collectionView.dataSource = self
        homeView.createButton.addTarget(self, action: #selector(showCreateEditEvent), for: .touchUpInside)
        homeView.joinButton.addTarget(self, action: #selector(showJoinEvent), for: .touchUpInside)
        fetchEvents()
        
    }
    
    @objc func showCreateEditEvent() {
        let createEditVC = CreateEditViewController()
        let createNav = UINavigationController.init(rootViewController: createEditVC)
        present(createNav, animated: true) 
    }
    @objc func showJoinEvent(){
        let joinVC = EventDetailsViewController()
        present (joinVC, animated: true)
        print("whaddup")
    }
    
    private var listener: ListenerRegistration!
    private var authService = AppDelegate.authservice
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        homeView.collectionView.refreshControl = rc
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
                    self?.events = snapshot.documents.map{Event(dict:                $0.data()) }
                    .sorted { $0.startDate.date() > $1.startDate.date() }
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            })
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventHomeCollectionViewCell", for: indexPath) as? EventHomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let eventToSet = events[indexPath.row]
        collectionViewCell.eventLabel.text = eventToSet.eventName
        print(eventToSet.startDate)
        //No start date populating
        collectionViewCell.dayLabel.text = eventToSet.startDate.description
        collectionViewCell.backgroundView = UIImageView(image: UIImage(named: "pitons"))
        collectionViewCell.layer.cornerRadius = 15
        return collectionViewCell
    }
    
    
}
