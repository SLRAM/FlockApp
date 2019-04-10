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
    
    let fakeFriends = ["test 1", "test 2"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        friendsView.delegate = self
        view.addSubview(friendsView)
        friendListButton()
        friendsView.myTableView.delegate = self
        friendsView.myTableView.dataSource = self

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
        delegate?.selectedFriends(friends: fakeFriends)
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let friend = fakeFriends[indexPath.row]
        cell.textLabel?.text = friend.description
        return cell
    }
    
    
}
