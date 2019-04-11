//
//  CreateEditViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import MapKit
import GoogleMaps
import Firebase

class CreateEditViewController: UIViewController {
    
    private let createEditView = CreateEditView()
    let titlePlaceholder = "Enter the quiz title"
    let firstPlaceholder = "Enter first quiz fact"
    let secondPlaceholder = "Enter second quiz fact"
    
    var friendsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(createEditView)
        createEditView.titleTextView.delegate = self
        createEditView.delegate = self
        createEditView.myTableView.dataSource = self
        createEditView.myTableView.delegate = self
        navigationItem.rightBarButtonItem = createEditView.createButton
    }
    override func viewDidAppear(_ animated: Bool) {
    }
}
extension CreateEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        createEditView.titleTextView.becomeFirstResponder()
        if createEditView.titleTextView.text == self.titlePlaceholder {
            createEditView.titleTextView.text = ""
            createEditView.titleTextView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        createEditView.titleTextView.resignFirstResponder()
    }
}
extension CreateEditViewController: CreateViewDelegate {
    func friendsPressed() {
        print("friends pressed")
        let detailVC = FriendsViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func trackingPressed() {
        print("tracking pressed")
    }
    
    func datePressed() {
        print("date pressed")

//        let detailVC = LocationSearchViewController() change to dateviewcontroller
//        detailVC.delegate = self
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func addressPressed() {
        let detailVC = LocationSearchViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func createPressed() {
        if createEditView.titleTextView.text == titlePlaceholder {
            let alertController = UIAlertController(title: "Please enter in some information other than the placeholder", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else if createEditView.titleTextView.text == ""{
            let alertController = UIAlertController(title: "Please do not leave any sections blank", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else {
//            guard let username = UserDefaults.standard.string(forKey: UserDefaultsKeys.usernameKey) else {return}
//            let username = "username"
//            if QuizModel.quizAlreadyCreated(newTitle: createView.titleTextView.text, username: username) {
//                self.setQuizMessage(bool: false)
//            } else {
//                guard let quiz = self.saveQuiz() else {
//                    print("Failed to save quiz")
//                    return
//                }
//                QuizModel.appendQuiz(quiz: quiz)
//                self.setQuizMessage(bool: true)
//                self.createView.titleTextView.text = titlePlaceholder
//                self.createView.firstQuizTextView.text = firstPlaceholder
//                self.createView.secondQuizTextView.text = secondPlaceholder
//                self.createView.resignFirstResponder()
//            }
        }
    }
}

extension CreateEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let friend = friendsArray[indexPath.row]
        cell.textLabel?.text = friend
        return cell
    }
    
    
}

extension CreateEditViewController: LocationSearchViewControllerDelegate {
    func getLocation(locationTuple: (String, CLLocationCoordinate2D)) {
            print("tuple printout of string: \(locationTuple.0)")
            print("tuple printout of coordinates: \(locationTuple.1)")
            createEditView.addressButton.setTitle(locationTuple.0, for: .normal)
            createEditView.addressButton.titleLabel?.text = locationTuple.0
    }
}
extension CreateEditViewController: FriendsViewControllerDelegate {
    func selectedFriends(friends: [String]) {
        print("Friends selected")
        friendsArray = friends
        createEditView.myTableView.reloadData()
    }
    
    
}
