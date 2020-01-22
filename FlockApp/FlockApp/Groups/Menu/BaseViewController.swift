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
			homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: false)
        case "Profile":
            let profileVC = ProfileViewController()
			profileVC.modalPresentationStyle = .fullScreen
            present(profileVC, animated: false)
        case "Friends":
            let friendsVC = FriendsViewController()
			friendsVC.modalPresentationStyle = .fullScreen
            let friendsNav = UINavigationController.init(rootViewController: friendsVC)
            present(friendsNav, animated: false)
        case "Settings":
            let settingsVC = SettingsViewController()
			settingsVC.modalPresentationStyle = .fullScreen
            present(settingsVC, animated: false)
        case "Sign Out":
            AppDelegate.authservice.signOutAccount()
            showLoginView()
        default:
            return
        }
    }
}
