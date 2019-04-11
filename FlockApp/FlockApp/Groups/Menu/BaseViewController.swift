//
//  BaseViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import UIKit

class BaseViewController: UIViewController {
    let menuLauncher = MenuLauncher()
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: menuLauncher, action: #selector(MenuLauncher.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        menuLauncher.baseVC = self
    }
    
    func showViewController(keyword: String) {
        switch keyword {
        case "Events":
            let homeVC = HomeViewController()
            present(homeVC, animated: false)
        case "Profile":
            let profileVC = ProfileViewController()
            present(profileVC, animated: false)
        case "Friends":
            let friendsVC = FriendsViewController()
            present(friendsVC, animated: false)
        case "Settings":
            let settingsVC = SettingsViewController()
            present(settingsVC, animated: false)
        case "Sign Out":
            AppDelegate.authservice.signOutAccount()
            showLoginView()
        default:
            return
        }
    }
}
