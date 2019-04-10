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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(createEditView)
        createEditView.titleTextView.delegate = self
        createEditView.firstQuizTextView.delegate = self
        createEditView.secondQuizTextView.delegate = self
        createEditView.delegate = self
        navigationItem.rightBarButtonItem = createEditView.createButton
        checkLoggedIn()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkLoggedIn()
    }
    func checkLoggedIn() {
        let username = "username"
        if username == "@username" {
            navigationItem.rightBarButtonItem?.isEnabled = false
            createEditView.titleTextView.isEditable = false
            createEditView.firstQuizTextView.isEditable = false
            createEditView.secondQuizTextView.isEditable = false
            
            let alertController = UIAlertController(title: "No user logged in.", message: "To access this feature you need to login on the profile tab.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            createEditView.titleTextView.isEditable = true
            createEditView.firstQuizTextView.isEditable = true
            createEditView.secondQuizTextView.isEditable = true
        }
    }
}
extension CreateEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            createEditView.titleTextView.becomeFirstResponder()
            if createEditView.titleTextView.text == titlePlaceholder {
                createEditView.titleTextView.text = ""
                createEditView.titleTextView.textColor = .black
            }
        case 1:
            createEditView.firstQuizTextView.becomeFirstResponder()
            if createEditView.firstQuizTextView.text == firstPlaceholder {
                createEditView.firstQuizTextView.text = ""
                createEditView.firstQuizTextView.textColor = .black
            }
        case 2:
            createEditView.secondQuizTextView.becomeFirstResponder()
            if createEditView.secondQuizTextView.text == secondPlaceholder {
                createEditView.secondQuizTextView.text = ""
                createEditView.secondQuizTextView.textColor = .black
            }
        default:
            print("error selecting create text views")
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            createEditView.titleTextView.resignFirstResponder()
        case 1:
            createEditView.titleTextView.resignFirstResponder()
        case 2:
            createEditView.titleTextView.resignFirstResponder()
        default:
            print("error leaving create text views")
        }
    }
}
extension CreateEditViewController: CreateViewDelegate {
    func addressPressed() {
        let detailVC = LocationSearchViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func createPressed() {
        if createEditView.titleTextView.text == titlePlaceholder || createEditView.firstQuizTextView.text == firstPlaceholder || createEditView.secondQuizTextView.text == secondPlaceholder {
            let alertController = UIAlertController(title: "Please enter in some information other than the placeholder", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else if createEditView.titleTextView.text == "" || createEditView.firstQuizTextView.text == "" || createEditView.secondQuizTextView.text == ""{
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
extension CreateEditViewController: LocationSearchViewControllerDelegate {
    func getLocation(locationTuple: (String, CLLocationCoordinate2D)) {
            print("tuple printout of string: \(locationTuple.0)")
            print("tuple printout of coordinates: \(locationTuple.1)")
            createEditView.addressButton.setTitle(locationTuple.0, for: .normal)
            createEditView.addressButton.titleLabel?.text = locationTuple.0
    }
}
