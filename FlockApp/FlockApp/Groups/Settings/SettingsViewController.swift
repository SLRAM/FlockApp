//
//  SettingsViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/11/19.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    let settingsView = SettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingsView)
    }
}


