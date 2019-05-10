//
//  TabBarController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/16/19.
//

import UIKit

class TabBarController: UITabBarController {
    private var authservice = AppDelegate.authservice

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }
    private func setupTabBarController(){
        guard let user = authservice.getCurrentUser() else {
            print("No logged user")
            return
        }
        
        let firstViewController = HomeViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "event"), tag: 0)
        
        let firstNav = UINavigationController.init(rootViewController: firstViewController)
        //        firstNav.navigationBar.barTintColor = UIColor.black
        //        firstNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let secondViewController = ProfileViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 1)
        DBService.fetchUser(userId: user.uid) { (error, loggedUser) in
            if let error = error {
                print("Failed to fetch user in TabBarController: \(error.localizedDescription)")
            } else if let loggedUser = loggedUser {
                secondViewController.profileView.displayNameTextView.text = loggedUser.displayName
                secondViewController.profileView.firstNameTextView.text = loggedUser.fullName
                secondViewController.profileView.phoneNumberTextView.text = loggedUser.phoneNumber
                secondViewController.profileView.emailTextView.text = loggedUser.email
                if let image = loggedUser.photoURL {
                    secondViewController.profileView.imageButton.kf.setImage(with: URL(string: image), for: .normal)
                }
            }
        }
        secondViewController.profileView.addFriend.isHidden = true
        secondViewController.profileView.addFriend.isEnabled = false
        secondViewController.profileView.blockButton.isHidden = true
        secondViewController.profileView.blockButton.isEnabled = false
        secondViewController.profileView.editButton.isEnabled = true
        secondViewController.profileView.editButton.isHidden = false
        secondViewController.profileView.addFriend.isEnabled = false
        secondViewController.profileView.addFriend.isHidden = true
        secondViewController.profileView.blockButton.isEnabled = false
        secondViewController.profileView.blockButton.isHidden = true
        secondViewController.profileView.signOutButton.isEnabled = true
        secondViewController.profileView.signOutButton.isHidden = false
        
        let secondNav = UINavigationController.init(rootViewController: secondViewController)
        
        
        
        let thirdViewController = FriendsViewController()
        thirdViewController.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "friends"), tag: 2)
        
        let thirdNav = UINavigationController.init(rootViewController: thirdViewController)
        
        
        //        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        let tabBarList = [firstNav,secondNav,thirdNav]
        
        viewControllers = tabBarList
    }

}
