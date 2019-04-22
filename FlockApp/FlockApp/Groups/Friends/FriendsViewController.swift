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
    private var strangers = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsView.myTableView.reloadData()
            }
        }
    }
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(friendsView)
        friendsView.friendSearch.delegate = self
        friendsView.myTableView.delegate = self
        friendsView.myTableView.dataSource = self
        friendsView.myTableView.tableFooterView = UIView()
//        navigationController?.navigationBar.topItem?.title = ""

    }
    override func viewWillAppear(_ animated: Bool) {
        setupTable(keyword: "")
    }
    private func setupTable(keyword: String) {
        fetchFriends(keyword: keyword)
        //timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(fetchStrangers(keyword:)), userInfo: keyword, repeats: false)
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
                    self!.fetchFriendInfo(list: test, keyword: keyword)
                }
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
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    guard let friends = self?.friends else { return }
                    if text == "" {
                        self?.strangers.removeAll()
                        let str = snapshot.documents.map { UserModel(dict: $0.data()) }
                        str.forEach { userModel in
                            if !friends.contains(userModel) && userModel.userId != user.uid {
                                self?.strangers.append(userModel)
                            }
                            self!.strangers = (self?.strangers.sorted { $0.displayName.lowercased() < $1.displayName.lowercased() })!
                        }
                } else {
                    self?.strangers.removeAll()
                    let str = snapshot.documents.map { UserModel(dict: $0.data()) }
//                        .filter({$0.displayName.lowercased().contains(text.lowercased())})
//                        .sorted { $0.displayName.lowercased() < $1.displayName.lowercased() }
                    str.forEach { userModel in
                        if !friends.contains(userModel) && userModel.userId != user.uid {
                            self?.strangers.append(userModel)
                        }
                        self!.strangers = (self?.strangers.sorted { $0.displayName.lowercased() < $1.displayName.lowercased() })!
                            .filter({$0.displayName.lowercased().contains(text.lowercased())})
                    }
                }
            }
        }
    }
    private func fetchFriendInfo(list: [String], keyword: String) {
        guard !list.isEmpty else {
            fetchStrangers(keyword: keyword)
            friends = friends.sorted {$0.displayName.lowercased() < $1.displayName.lowercased()}
            return
        }
        var currentList = list
        guard let friend = currentList.popLast() else {return}
        DBService.fetchUser(userId: friend) { (error, user) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let user = user {
                    if keyword == "" {
                        self.friends.append(user)
                    } else if user.displayName.lowercased().contains(keyword.lowercased()) {
                        self.friends.append(user)
                    }
                    self.fetchFriendInfo(list: currentList, keyword: keyword)
            }
        }
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
             return friends.count
        case 1:
            return strangers.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !friends.isEmpty else { return UITableViewCell() }
        guard !strangers.isEmpty else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let userCell = friends[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = userCell.displayName
            cell.detailTextLabel?.text = "Friend"
            cell.backgroundColor = .clear
            return cell
        case 1 :
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
            let user = strangers[indexPath.row]
            profileVC.user = user
            navigationController?.pushViewController(profileVC, animated: false)
        default:
            return
        }
    }
}
