//
//  InvitedViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/10/19.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseFirestore

protocol InvitedViewControllerDelegate: AnyObject {
    func selectedFriends(friends: [UserModel])
}

class InvitedViewController: BaseViewController {

    weak var delegate: InvitedViewControllerDelegate?
    private let invitedView = InvitedView()
    var emptyState = EmptyStateView()
    var isSearching = false
    var savedFriends = [UserModel]()

    private var friends = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.invitedView.myTableView.reloadData()
            }
            self.setupEmptyState()

        }
    }
    private var filteredFriends = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.invitedView.myTableView.reloadData()
            }
        }
    }
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        invitedView.myTableView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchFriends), for: .valueChanged)
        return rc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Friends"
        view.addSubview(invitedView)
        friendListButton()
        invitedView.friendSearch.delegate = self
        invitedView.myTableView.delegate = self
        invitedView.myTableView.dataSource = self
        invitedView.myTableView.tableFooterView = UIView()
        fetchFriends()
//        setupEmptyState()
    }
    func setupEmptyState() {
        if friends.isEmpty {
            invitedView.myTableView.backgroundView = emptyState
            emptyState.emptyStateLabel.text = "No friends available. You can request some in the friends tab."
        } else {
            invitedView.myTableView.backgroundView = UIView()
        }
    }
    
    @objc private func fetchFriends() {
        friends.removeAll()
        refreshControl.beginRefreshing()
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
                    let test: [String] = snapshot.documents.map {
                        let dictionary =  $0.data() as? [String:String]
                        guard let key = dictionary?.keys.first else { return "" }
                        return key
                    }
                    self!.fetchFriendInfo(list: test)
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
        }
    }
    private func fetchFriendInfo(list: [String]) {
        for friend in list {
            DBService.fetchUser(userId: friend) { (error, user) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let user = user {
                    self.friends.append(user)
                }
            }
        }
    }
    func friendListButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .plain, target: self, action: #selector(addButton))
    }
    
    @objc func addButton() {
        delegate?.selectedFriends(friends: savedFriends)
        self.navigationController?.popViewController(animated: true)
    }
}
extension InvitedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredFriends.count
        } else {
            return friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = invitedView.myTableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        cell.taskField.isHidden = true
        cell.backgroundColor = .clear
        if isSearching {
            let friend = filteredFriends[indexPath.row]
            cell.profilePicture.kf.setImage(with: URL(string: friend.photoURL ?? "no photo"), placeholder: #imageLiteral(resourceName: "ProfileImage.png"))
            cell.nameLabel.text = friend.displayName
            if savedFriends.contains(where: { $0.displayName == friend.displayName}){
                cell.accessoryType = .checkmark
            }
            return cell
            
        } else {
            let friend = friends[indexPath.row]
            cell.profilePicture.kf.setImage(with: URL(string: friend.photoURL ?? "no photo"), placeholder: #imageLiteral(resourceName: "ProfileImage.png"))
            cell.nameLabel.text = friend.displayName
            if savedFriends.contains(where: { $0.displayName == friend.displayName}) {
                cell.accessoryType = .checkmark
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        invitedView.friendSearch.resignFirstResponder()

        if isSearching {
            let friend = filteredFriends[indexPath.row]
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                var counter = 0
                for savedFriend in savedFriends {
                    if savedFriend.userId != friend.userId {
                        counter += 1
                    } else {
                        savedFriends.remove(at: counter)
                    }
                }
                
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                savedFriends.append(friend)
            }
        } else {
            let friend = friends[indexPath.row]
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                var counter = 0
                for savedFriend in savedFriends {
                    if savedFriend.userId != friend.userId {
                        counter += 1
                    } else {
                        savedFriends.remove(at: counter)
                    }
                }
                
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                savedFriends.append(friend)
            }
        }
    }
}

extension InvitedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            view.endEditing(true)
        } else {
            isSearching = true
            filteredFriends = friends.filter({$0.displayName.lowercased().contains(searchText.lowercased())})
        }
        invitedView.myTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
