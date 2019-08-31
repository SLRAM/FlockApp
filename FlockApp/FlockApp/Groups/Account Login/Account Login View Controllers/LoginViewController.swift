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
//        let homeViewController = HomeViewController()
//        homeViewController.modalTransitionStyle = .crossDissolve
//        homeViewController.modalPresentationStyle = .overFullScreen
//        present(homeViewController, animated: true)
        let mainTabBarController = TabBarController()
//        mainTabBarController.modalTransitionStyle = .crossDissolve
//        mainTabBarController.modalPresentationStyle = .overFullScreen
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//        UITabBar.appearance().tintColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
        present(mainTabBarController, animated: true)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
