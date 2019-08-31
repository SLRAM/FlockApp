//
//  LoginViewController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/8/19.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authservice.authserviceExistingAccountDelegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        registerKeyboardNotifications()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        unregisterKeyboardNofications()
//    }
//
//    deinit {
//    }
//
//    private func registerKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    private func unregisterKeyboardNofications() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//
//    @objc private func willShowKeyboard(notification: Notification) {
//
//        guard let info = notification.userInfo,
//            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
//                print("userinfo is nil")
//                return
//        }
//
//        emailTextField.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
//        passwordTextField.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
//
//
//
//    }
//
//    @objc private func willHideKeyboard(notification: Notification) {
//        emailTextField.transform = CGAffineTransform.identity
//        passwordTextField.transform = CGAffineTransform.identity
//
//
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                return
        }
        authservice.signInExistingAccount(email: email, password: password)
    }
}

extension LoginViewController: AuthServiceExistingAccountDelegate {
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Signin Error", message: error.localizedDescription)
    }
    
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        let mainTabBarController = TabBarController()
        present(mainTabBarController, animated: true)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
