//
//  CreateEditViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

class CreateEditViewController: UIViewController {
    
    private let createView = CreateEditView()
    var quiz: UserModel?
    let titlePlaceholder = "Enter the quiz title"
    let firstPlaceholder = "Enter first quiz fact"
    let secondPlaceholder = "Enter second quiz fact"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(createView)
        createView.titleTextView.delegate = self
        createView.firstQuizTextView.delegate = self
        createView.secondQuizTextView.delegate = self
        createView.delegate = self
        navigationItem.rightBarButtonItem = createView.createButton
        checkLoggedIn()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkLoggedIn()
    }
    func checkLoggedIn() {
        let username = "username"
        if username == "@username" {
            navigationItem.rightBarButtonItem?.isEnabled = false
            createView.titleTextView.isEditable = false
            createView.firstQuizTextView.isEditable = false
            createView.secondQuizTextView.isEditable = false
            
            let alertController = UIAlertController(title: "No user logged in.", message: "To access this feature you need to login on the profile tab.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            createView.titleTextView.isEditable = true
            createView.firstQuizTextView.isEditable = true
            createView.secondQuizTextView.isEditable = true
        }
    }
    
    private func saveQuiz()-> UserModel? {
        guard let quizTitle = createView.titleTextView.text,
            let firstFact = createView.firstQuizTextView.text,
            let secondFact = createView.secondQuizTextView.text else {return nil}
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
            createView.titleTextView.becomeFirstResponder()
            if createView.titleTextView.text == titlePlaceholder {
                createView.titleTextView.text = ""
                createView.titleTextView.textColor = .black
            }
        case 1:
            createView.firstQuizTextView.becomeFirstResponder()
            if createView.firstQuizTextView.text == firstPlaceholder {
                createView.firstQuizTextView.text = ""
                createView.firstQuizTextView.textColor = .black
            }
        case 2:
            createView.secondQuizTextView.becomeFirstResponder()
            if createView.secondQuizTextView.text == secondPlaceholder {
                createView.secondQuizTextView.text = ""
                createView.secondQuizTextView.textColor = .black
            }
        default:
            print("error selecting create text views")
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            createView.titleTextView.resignFirstResponder()
        case 1:
            createView.titleTextView.resignFirstResponder()
        case 2:
            createView.titleTextView.resignFirstResponder()
        default:
            print("error leaving create text views")
        }
    }
}
extension CreateEditViewController: CreateViewDelegate {
    func createPressed() {
        if createView.titleTextView.text == titlePlaceholder || createView.firstQuizTextView.text == firstPlaceholder || createView.secondQuizTextView.text == secondPlaceholder {
            let alertController = UIAlertController(title: "Please enter in some information other than the placeholder", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else if createView.titleTextView.text == "" || createView.firstQuizTextView.text == "" || createView.secondQuizTextView.text == ""{
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
