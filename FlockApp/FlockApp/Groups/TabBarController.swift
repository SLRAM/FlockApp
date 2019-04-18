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
        
        let firstViewController = EventViewController()
        
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "event"), tag: 0)
        
        let secondViewController = ProfileViewController()
        
        secondViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 1)
        
        let thirdViewController = FriendsViewController()
        
        thirdViewController.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "friends"), tag: 2)
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        
        viewControllers = tabBarList
    }
    

}
