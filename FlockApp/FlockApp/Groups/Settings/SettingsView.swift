//
//  SettingsView.swift
//  FlockApp
//
//  Created by Biron Su on 4/11/19.
//

import UIKit

class SettingsView: UIView {
    
    //display email, number, full name between public and friends

    lazy var displayEmail: UILabel = {
       let label = UILabel()
        label.text = "Display Email"
        return label
    }()
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        backgroundColor = .white
    }
}
