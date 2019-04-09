//
//  CreateEditViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import MapKit
import GoogleMaps

class CreateEditViewController: UIViewController {
    
    private let createEditView = CreateEditView()
    var quiz: UserModel?
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
    
    private func saveQuiz()-> UserModel? {
        guard let quizTitle = createEditView.titleTextView.text,
            let firstFact = createEditView.firstQuizTextView.text,
            let secondFact = createEditView.secondQuizTextView.text else {return nil}
        let facts = [firstFact,secondFact]
//        guard let username = UserDefaults.standard.string(forKey: UserDefaultsKeys.usernameKey) else {return nil}
        let username = "username"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = .medium
        let timestamp = formatter.string(from: date)
        let quiz = UserModel.init(userId: "One", displayName: "one", email: "one@email.com", photoURL: nil, coverImageURL: nil, joinedDate: Date.getISOTimestamp(), firstName: nil, lastName: nil, bio: nil)
        
        return quiz
    }
    
    private func setQuizMessage(bool: Bool) {
        if bool {
            let alert = UIAlertController(title: "Your Quiz has been saved!", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Sorry that quiz exists already!", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
    func createsPressed() {
        let detailVC = LocationSearchViewController()
        detailVC.delegate = self
        detailVC.tag = 0
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
    func getLocation(buttonTag: Int, locationTuple: (String, CLLocationCoordinate2D)) {
        if buttonTag == 0 {
            print("tuple printout of string: \(locationTuple.0)")
            print("tuple printout of coordinates: \(locationTuple.1)")
//            startingCoordinate = locationTuple.1
            createEditView.createsButton.setTitle(locationTuple.0, for: .normal)
            createEditView.createsButton.titleLabel?.text = locationTuple.0
//            startingAddressButton.setTitle(locationTuple.0, for: .normal)
//            startingAddressButton.titleLabel?.text = locationTuple.0
        } else {
            print("tuple printout of string: \(locationTuple.0)")
            print("tuple printout of coordinates: \(locationTuple.1)")
//            endingCoordinate = locationTuple.1
//            endingAddressButton.setTitle(locationTuple.0, for: .normal)
//            endingAddressButton.titleLabel?.text = locationTuple.0
        }
    }
}
