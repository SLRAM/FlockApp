//
//  FriendsViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseFirestore

class FriendsViewController: BaseViewController {

    let friendsView = FriendsView()
    
    private var friends = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsView.myTableView.reloadData()
            }
        }
    }
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(friendsView)
        navigationController?.setNavigationBarHidden(true, animated: false)
        friendsView.friendSearch.delegate = self
        friendsView.myTableView.delegate = self
        friendsView.myTableView.dataSource = self
        friendsView.myTableView.tableFooterView = UIView()
        fetchFriends(keyword: "")
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func fetchFriends(keyword: String) {
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    if keyword == "" {
                        self?.friends = snapshot.documents.map { UserModel(dict: $0.data()) }
                            .sorted { $0.displayName.lowercased() < $1.displayName.lowercased() }
                    } else {
                        self?.friends = snapshot.documents.map { UserModel(dict: $0.data()) }
                            .filter({$0.displayName.lowercased().contains(keyword.lowercased())})
                            .sorted { $0.displayName.lowercased() < $1.displayName.lowercased() }
                    }
                    
                    //do filtered here
                }
        }
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = friend.displayName
        cell.backgroundColor = .clear
        
        return cell
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchFriends(keyword: searchText)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = friendsView.myTableView.indexPathForSelectedRow else {
            fatalError("It broke")
        }
        let profileVC = ProfileViewController()
        let user = friends[indexPath.row]
        profileVC.user = user
        let profileNav = UINavigationController.init(rootViewController: profileVC)
        navigationController?.pushViewController(profileVC, animated: false)
//        present(profileNav, animated: true, completion: nil)
    }
}
