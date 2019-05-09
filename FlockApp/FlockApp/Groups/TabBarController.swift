//
//  TabBarController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/16/19.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController = HomeViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "event"), tag: 0)
        
        let firstNav = UINavigationController.init(rootViewController: firstViewController)
//        firstNav.navigationBar.barTintColor = UIColor.black
//        firstNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let secondViewController = ProfileViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 1)
        
        let secondNav = UINavigationController.init(rootViewController: secondViewController)

        
        
        let thirdViewController = FriendsViewController()
        thirdViewController.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "friends"), tag: 2)
        
        let thirdNav = UINavigationController.init(rootViewController: thirdViewController)

        
//        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        let tabBarList = [firstNav,secondNav,thirdNav]
        
        viewControllers = tabBarList
    }
    

}
