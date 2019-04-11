//
//  FriendsViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/10/19.
//

import UIKit

protocol FriendsViewControllerDelegate: AnyObject {
    func selectedFriends(friends: [String])
//    func selectedFriends(friends: [UserModel])
}

class FriendsViewController: UIViewController {

    weak var delegate: FriendsViewControllerDelegate?
    private let friendsView = FriendsView()
    var isSearching = false

    var savedFriends = [String]()

    
    let friends = ["test 1", "test 2"]
    
    var filteredFriends = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        friendsView.delegate = self
        view.addSubview(friendsView)
        
        friendListButton()
        friendsView.friendSearch.delegate = self

        friendsView.myTableView.delegate = self
        friendsView.myTableView.dataSource = self
        friendsView.myTableView.tableFooterView = UIView()


    }
    
    func friendListButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .plain, target: self, action: #selector(addButton))
    }
    
    @objc func addButton() {
//        guard let noLocation = locationSearchView.locationSearch.text?.isEmpty else {return}
        // if no checkmarks do this
//        if noSelections {
//            let alertController = UIAlertController(title: "Please provide a selections of friends to add to your event.", message: nil, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(okAction)
//            present(alertController, animated: true)
//        } else {
////            delegate?.getLocation(locationTuple: locationTuple)
//            print("saved")
//            let alertController = UIAlertController(title: "These friends have been added to your event.", message: nil, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                self.navigationController?.popViewController(animated: true)
//
//            })
//            alertController.addAction(okAction)
//            present(alertController, animated: true)
//        }
        //convert to a list of check off users userIDs
        delegate?.selectedFriends(friends: savedFriends)
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredFriends.count
        } else {
            return friends.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//        let friend = friends[indexPath.row]
//        cell.textLabel?.text = friend.description
//        return cell
        
        var friend = String()
        if isSearching {
            friend = filteredFriends[indexPath.row]
        } else {
            friend = friends[indexPath.row]
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = friend
        cell.backgroundColor = .clear

        if savedFriends.contains(friend) {
            cell.accessoryType = .checkmark
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var friend = String()
        if isSearching {
            friend = filteredFriends[indexPath.row]
            
        } else {
            friend = friends[indexPath.row]
        }
        //        print(bus)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            var counter = 0
            for savedFriend in savedFriends {
                if savedFriend != friend {
                    counter += 1
                } else {
                    //                    print(counter)
                    savedFriends.remove(at: counter)
                }
            }
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            savedFriends.append(friend)
        }
        
    }
    
    
}

extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            view.endEditing(true)
        } else {
            isSearching = true
            filteredFriends = friends.filter({$0.lowercased().contains(searchText.lowercased())})
        }
        friendsView.myTableView.reloadData()
    }
}
