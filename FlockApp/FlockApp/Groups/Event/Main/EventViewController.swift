//
//  EventViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

class EventViewController: UIViewController {
    
    let eventView = EventView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(eventView)
//        eventView.delegate = self
    }
    


}

//height for view around 75%
