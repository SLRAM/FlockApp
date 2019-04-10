//
//  BaseViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import UIKit

class BaseViewController: UIViewController {
    let menuLauncher = MenuLauncher()
    let authservice = AuthService()
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
            present(homeVC, animated: false, completion: nil)
        case "Sign Out":
            authservice.signOutAccount()
            showLoginView()
        default:
            return
        }
    }
}
