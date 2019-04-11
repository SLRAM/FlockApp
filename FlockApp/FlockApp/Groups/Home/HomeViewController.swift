//
//  HomeViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController {
    
    var homeView = HomeView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeView)
        view.backgroundColor = .white
        homeView.createButton.addTarget(self, action: #selector(showCreateEditEvent), for: .touchUpInside)
        
    }
    
    @objc func showCreateEditEvent() {
        let createEditVC = CreateEditViewController()
        let createNav = UINavigationController.init(rootViewController: createEditVC)
        present(createNav, animated: true) 
    }

 
    

}
