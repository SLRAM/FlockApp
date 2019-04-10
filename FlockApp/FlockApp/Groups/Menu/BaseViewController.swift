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
            present(homeVC, animated: true, completion: nil)
        case "Profile":
            let create = CreateEditViewController()
            present(create, animated: true, completion: nil)
        default:
            return
        }
    }
}
