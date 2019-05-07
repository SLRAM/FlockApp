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
    var allUsers = [UserModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(friendsView)
        friendsView.myTableView.delegate = self
        friendsView.myTableView.dataSource = self
        friendsView.friendSearch.delegate = self
        friendsView.myTableView.tableFooterView = UIView()
        navigationController?.navigationBar.topItem?.title = "Flockers"
        tapGestureKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchAllUsers(keyword: "")
        fetchFriends(keyword: "")
    }
    private func tapGestureKeyboard(){
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.friendsView.friendSearch.resignFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        let layer = CAGradientLayer()
        layer.frame = UIScreen.main.bounds
        layer.colors = [#colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1).cgColor, UIColor.white.cgColor]
        let myTest = UIView.init(frame: UIScreen.main.bounds)

//        myTest.layer.addSublayer(layer)
        myTest.layer.insertSublayer(layer, at: 0)
        self.friendsView.myTableView.backgroundView = myTest
    }
   
    private func fetchPendingFriends(keyword: String) {
            guard let user = authservice.getCurrentUser() else {
                print("Please log in")
                return
            }
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(FriendsCollectionKey.PendingKey)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    let test : [String] = snapshot.documents.map {
                        $0.documentID
                    }
                    self!.pending = self!.allUsers.filter {
                        test.contains($0.userId)
                    }
                    if keyword != "" {
                        self!.pending = self!.pending.filter {
                            $0.displayName.lowercased().contains(keyword.lowercased())
                        }
                        self?.friendsView.myTableView.reloadData()
                    }
                    self!.getStrangers(keyword: keyword)
                }
        }
    }
    private func fetchRequestedFriends(keyword: String) {
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
                        $0.documentID
                    }
                    self!.request = self!.allUsers.filter {
                        test.contains($0.userId)
                    }
                    if keyword != "" {
                        self!.request = self!.request.filter {
                            $0.displayName.lowercased().contains(keyword.lowercased())
                        }
                        self?.friendsView.myTableView.reloadData()
                    }
                    self!.fetchPendingFriends(keyword: keyword)
                    
                }
        }
    }
    private func fetchFriends(keyword: String) {
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
                        $0.documentID
                    }
                    self!.friends = self!.allUsers.filter {
                        test.contains($0.userId)
                    }
                    if keyword != "" {
                        self!.friends = self!.friends.filter {
                            $0.displayName.lowercased().contains(keyword.lowercased())
                        }
                        self?.friendsView.myTableView.reloadData()
                    }
                    self!.fetchRequestedFriends(keyword: keyword)
                    
                }
        }
    }
    private func getStrangers(keyword: String) {
        self.strangers = self.allUsers.filter {
            !friends.contains($0) &&
            !pending.contains($0) &&
            !request.contains($0)
        }
        if keyword != "" {
            self.strangers = self.strangers.filter({$0.displayName.lowercased().contains(keyword.lowercased())})
        }
        self.friendsView.myTableView.reloadData()
    }
    
    @objc private func fetchAllUsers(keyword: String) {
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
                    if keyword == "" {
                        self!.allUsers = snapshot.documents.map { UserModel(dict: $0.data())}
                            .sorted { $0.displayName.lowercased() < $1.displayName.lowercased()}
                            .filter({$0.userId != user.uid})
                } else {
                    self!.allUsers = snapshot.documents.map { UserModel(dict: $0.data())}
                        .sorted { $0.displayName.lowercased() < $1.displayName.lowercased()}
                        .filter({$0.userId != user.uid})
                        .filter({$0.displayName.lowercased().contains(keyword.lowercased())})
                }
            }
        }
    }
    @objc private func cancelRequest(sender: UIButton) {
        DBService.cancelRequest(cancelRequest: request[sender.tag]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    @objc private func declinePending(sender: UIButton) {
        DBService.declinePending(pendingDecline: pending[sender.tag]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    @objc private func acceptPending(sender: UIButton) {
        DBService.addFriend(friend: pending[sender.tag]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
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
            guard !friends.isEmpty else {return FriendsTableViewCell() }
            let userCell = friends[indexPath.row]
            let cell = FriendsTableViewCell(style: .default, reuseIdentifier: nil)
            cell.nameLabel.text = userCell.displayName
            cell.taskLabel.text = "Friend"
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.35)
            cell.layer.cornerRadius = 50
            cell.profilePicture.kf.setImage(with: URL(string: userCell.photoURL ?? "No Image Available"), placeholder: UIImage(named: "ProfileImage"))
            return cell
        case 1:
            guard !request.isEmpty else {return FriendsTableViewCell() }
            let userCell = request[indexPath.row]
            let cell = FriendsTableViewCell(style: .default, reuseIdentifier: nil)
            cell.nameLabel.text = userCell.displayName
            cell.taskLabel.text = "Request Sent"
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.35)
            cell.layer.cornerRadius = 50
            cell.profilePicture.kf.setImage(with: URL(string: userCell.photoURL ?? "No Image Available"), placeholder: UIImage(named: "ProfileImage"))
            cell.cancelRequest.isUserInteractionEnabled = true
            cell.cancelRequest.isHidden = false
            cell.cancelRequest.tag = indexPath.row
            cell.cancelRequest.addTarget(self, action: #selector(cancelRequest(sender:)), for: .touchUpInside)
            return cell
        case 2:
            guard !pending.isEmpty else {return FriendsTableViewCell() }
            let userCell = pending[indexPath.row]
            let cell = FriendsTableViewCell(style: .default, reuseIdentifier: nil)
            cell.nameLabel.text = userCell.displayName
            cell.taskLabel.text = "Friend Pending"
            cell.profilePicture.kf.setImage(with: URL(string: userCell.photoURL ?? "No Image Available"), placeholder: UIImage(named: "ProfileImage"))
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.35)
            cell.layer.cornerRadius = 50
            cell.acceptFriend.isUserInteractionEnabled = true
            cell.declineFriend.isUserInteractionEnabled = true
            cell.acceptFriend.isHidden = false
            cell.declineFriend.isHidden = false
            cell.acceptFriend.addTarget(self, action: #selector(acceptPending(sender:)), for: .touchUpInside)
            cell.declineFriend.addTarget(self, action: #selector(declinePending(sender:)), for: .touchUpInside)
            return cell
        case 3 :
            guard !strangers.isEmpty && indexPath.row < strangers.count else { return FriendsTableViewCell() }
            let userCell = strangers[indexPath.row]
            let cell = FriendsTableViewCell(style: .default, reuseIdentifier: nil)
            cell.nameLabel.text = userCell.displayName
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.35)
            cell.layer.cornerRadius = 50
            cell.profilePicture.kf.setImage(with: URL(string: userCell.photoURL ?? "No Image Available"), placeholder: UIImage(named: "ProfileImage"))
            return cell
        default:
            return FriendsTableViewCell()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            fetchAllUsers(keyword: searchText)
            fetchFriends(keyword: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
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
            profileVC.profileView.firstNameTextView.text = user.fullName
            profileVC.profileView.displayNameTextView.text = user.displayName
            profileVC.profileView.phoneNumberTextView.text = user.phoneNumber
            profileVC.profileView.emailTextView.text = "Hidden"
            profileVC.profileView.addFriend.setTitle("Remove Friend", for: .normal)
            if let image = user.photoURL, !image.isEmpty {
                profileVC.profileView.imageButton.kf.setImage(with: URL(string: image), for: .normal)
            }
            navigationController?.pushViewController(profileVC, animated: false)
        case 1:
            let user = request[indexPath.row]
            profileVC.user = user
            profileVC.profileView.firstNameTextView.text = user.fullName
            profileVC.profileView.displayNameTextView.text = user.displayName
            profileVC.profileView.phoneNumberTextView.text = user.phoneNumber
            profileVC.profileView.emailTextView.text = "Hidden"
            if let image = user.photoURL, !image.isEmpty {
                profileVC.profileView.imageButton.kf.setImage(with: URL(string: image), for: .normal)
            }
            navigationController?.pushViewController(profileVC, animated: false)
        case 2:
            let user = pending[indexPath.row]
            profileVC.user = user
            profileVC.profileView.firstNameTextView.text = user.fullName
            profileVC.profileView.displayNameTextView.text = user.displayName
            profileVC.profileView.phoneNumberTextView.text = user.phoneNumber
            profileVC.profileView.emailTextView.text = "Hidden"
            if let image = user.photoURL, !image.isEmpty {
                profileVC.profileView.imageButton.kf.setImage(with: URL(string: image), for: .normal)
            }
            navigationController?.pushViewController(profileVC, animated: false)
        case 3:
            let user = strangers[indexPath.row]
            profileVC.user = user
            profileVC.profileView.firstNameTextView.text = user.fullName
            profileVC.profileView.displayNameTextView.text = user.displayName
            profileVC.profileView.phoneNumberTextView.text = user.phoneNumber
            profileVC.profileView.emailTextView.text = "Hidden"
            if let image = user.photoURL, !image.isEmpty {
                profileVC.profileView.imageButton.kf.setImage(with: URL(string: image), for: .normal)
            }
            navigationController?.pushViewController(profileVC, animated: false)
        default:
            return
        }
    }
}
