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

class FriendsViewController: UIViewController {

    let friendsView = FriendsView()
    
    private var friends = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsView.myTableView.reloadData()
            }
        }
    }
    private var pending = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsView.myTableView.reloadData()
            }
        }
    }
    private var request = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsView.myTableView.reloadData()
            }
        }
    }
    private var strangers = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsView.myTableView.reloadData()
            }
        }
    }
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    var strangerFilter = [UserModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(friendsView)
        friendsView.myTableView.delegate = self
        friendsView.myTableView.dataSource = self
        friendsView.friendSearch.delegate = self
        friendsView.myTableView.tableFooterView = UIView()
        navigationController?.navigationBar.topItem?.title = "Flockers"
        

    }
    override func viewWillAppear(_ animated: Bool) {
        setupTable(keyword: "")
    }
    private func setupTable(keyword: String) {
        fetchFriends(keyword: keyword)
    }
    private func fetchPendingFriends(keyword: String) {
        self.pending.removeAll()
        guard let user = authservice.getCurrentUser() else {
            print("Please log in")
            return
        }
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(FriendsCollectionKey.PendingKey)
            .whereField(FriendsCollectionKey.RequestKey, isEqualTo: user.uid)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    let test : [String] = snapshot.documents.map {
                        let dictionary =  $0.data() as? [String:String]
                        guard let key = dictionary?.keys.first else { return "" }
                        return key
                    }

                    self!.fetchUserModel(type: "pending", list: test, keyword: keyword)
                    //self!.doFilter(keyword: keyword)
                    
                }
        }
    }
    private func fetchRequestedFriends(keyword: String) {
        self.request.removeAll()
        guard let user = authservice.getCurrentUser() else {
            print("Please log in")
            return
        }
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(FriendsCollectionKey.RequestKey)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch friend requests with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    let test : [String] = snapshot.documents.map {
                        let dictionary =  $0.data() as? [String:String]
                        guard let key = dictionary?.keys.first else { return "" }
                        return key
                    }
                    
                    self!.fetchUserModel(type: "request",list: test, keyword: keyword)
                    self!.fetchPendingFriends(keyword: keyword)
                    
                }
        }
    }
    private func fetchFriends(keyword: String) {
        self.friends.removeAll()
        guard let user = authservice.getCurrentUser() else {
            print("Please log in")
            return
        }
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(FriendsCollectionKey.CollectionKey)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    let test : [String] = snapshot.documents.map {
                        let dictionary =  $0.data() as? [String:String]
                        guard let key = dictionary?.keys.first else { return "" }
                        return key
                    }
                    self!.fetchRequestedFriends(keyword: keyword)
                    
                    self!.fetchUserModel(type: "friends",list: test, keyword: keyword)
                }
        }
    }
    private func doFilter(keyword: UserModel) {
        if !strangerFilter.contains(keyword) {
            strangerFilter.append(keyword)
        }
    }
    @objc private func fetchStrangers(keyword: String) {
        let text = keyword
        guard let user = authservice.getCurrentUser() else {
            print("Please log in")
            return
        }
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch strangers with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    if text == "" {
                        self?.strangers.removeAll()
                        let str = snapshot.documents.map { UserModel(dict: $0.data()) }
                        
                        str.forEach { userModel in
                            
                            if !self!.strangerFilter.contains(userModel) && userModel.userId != user.uid {
                                
                                self?.strangers.append(userModel)
            
                            }
                            self!.strangers = (self?.strangers.sorted { $0.displayName.lowercased() < $1.displayName.lowercased() })!
                        }
                } else {
                    self?.strangers.removeAll()
                    let str = snapshot.documents.map { UserModel(dict: $0.data()) }
                    str.forEach { userModel in
                        if !self!.strangerFilter.contains(userModel) && userModel.userId != user.uid {
                            self?.strangers.append(userModel)
                        }
                        self!.strangers = (self?.strangers.sorted { $0.displayName.lowercased() < $1.displayName.lowercased() })!
                            .filter({$0.displayName.lowercased().contains(text.lowercased())})
                    }
                }
            }
                self?.friendsView.myTableView.reloadData()
        }
    }
    private func fetchUserModel(type: String, list: [String], keyword: String) {
        
        guard !list.isEmpty else {
            if type == "pending" {
                self.fetchStrangers(keyword: keyword)
            }
            return
        }
        var currentList = list
        guard let userIDString = currentList.popLast() else {return}
        DBService.fetchUser(userId: userIDString) { (error, user) in
                if let error = error {
                    print("failed to fetch info with error: \(error.localizedDescription)")
                } else if let user = user {
                    switch type {
                    case "friends":
                        if keyword == "" {
                            self.friends.append(user)
                            self.doFilter(keyword: user)
                        } else if user.displayName.lowercased().contains(keyword.lowercased()) {
                            self.friends.append(user)
                            self.doFilter(keyword: user)

                        }
                    case "pending":
                        if keyword == "" {
                            self.pending.append(user)
                            self.doFilter(keyword: user)

                        } else if user.displayName.lowercased().contains(keyword.lowercased()) {
                            self.pending.append(user)
                            self.doFilter(keyword: user)

                        }
                    case "request":
                        if keyword == "" {
                            self.request.append(user)
                            self.doFilter(keyword: user)

                        } else if user.displayName.lowercased().contains(keyword.lowercased()) {
                            self.request.append(user)
                            self.doFilter(keyword: user)
                        }
                    default:
                        if keyword == "" {
                            self.doFilter(keyword: user)
                        } else if user.displayName.lowercased().contains(keyword.lowercased()) {
                            self.doFilter(keyword: user)
                        }
                    }
                    self.fetchUserModel(type: type, list: currentList, keyword: keyword)

                }
        }
        return
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case 0 :
             return friends.count
        case 1:
            return request.count
        case 2:
            return pending.count
        case 3:
            return strangers.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard !friends.isEmpty else {return UITableViewCell() }
            let userCell = friends[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = userCell.displayName
            cell.detailTextLabel?.text = "Friend"
            cell.backgroundColor = .clear
            return cell
        case 1:
            guard !request.isEmpty else {return UITableViewCell() }
            let userCell = request[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = userCell.displayName
            cell.detailTextLabel?.text = "Request Sent"
            cell.backgroundColor = .clear
            return cell
        case 2:
            guard !pending.isEmpty else {return UITableViewCell() }
            let userCell = pending[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = userCell.displayName
            cell.detailTextLabel?.text = "Pending"
            cell.backgroundColor = .clear
            return cell
        case 3 :
            guard !strangers.isEmpty && indexPath.row < strangers.count else { return UITableViewCell() }
            let userCell = strangers[indexPath.row]
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = userCell.displayName
            cell.backgroundColor = .clear
            return cell
        default:
            return UITableViewCell()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            setupTable(keyword: searchText)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = friendsView.myTableView.indexPathForSelectedRow else {
            fatalError("It broke")
        }
        let profileVC = ProfileViewController()
        switch indexPath.section {
        case 0:
            let user = friends[indexPath.row]
            profileVC.user = user
            navigationController?.pushViewController(profileVC, animated: false)
        case 1:
            let user = request[indexPath.row]
            profileVC.user = user
            navigationController?.pushViewController(profileVC, animated: false)
        case 2:
            let user = pending[indexPath.row]
            profileVC.user = user
            navigationController?.pushViewController(profileVC, animated: false)
        case 3:
            let user = strangers[indexPath.row]
            profileVC.user = user
            navigationController?.pushViewController(profileVC, animated: false)
        default:
            return
        }
    }
}
