//
//  CreateAccountViewController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/8/19.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authservice.authserviceCreateNewAccountDelegate = self
        
    }
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                print("missing fields") // TODO: add alert
                return
        }
        authservice.createNewAccount(username: username, email: email, password: password)
    }
    
    @IBAction func showLoginView(_ sender: UIButton) {
        let loginView = LoginViewController()
        present(loginView, animated: true) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            appDelegate.window?.rootViewController = loginView
        }
    }


}

extension CreateAccountViewController: AuthServiceCreateNewAccountDelegate {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
    
    func didCreateNewAccount(_ authservice: AuthService, user userModel: UserModel) {
        let mainTabBarController = TabBarController()
//        mainTabBarController.modalTransitionStyle = .crossDissolve
//        mainTabBarController.modalPresentationStyle = .overFullScreen
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
        present(mainTabBarController, animated: true)
    }
}
