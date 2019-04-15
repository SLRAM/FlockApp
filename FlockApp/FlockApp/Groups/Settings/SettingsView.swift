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
    
    lazy var displayPhoneNumber: UILabel = {
        let label = UILabel()
        label.text = "Display Phone #"
        return label
    }()
    
    lazy var displayFullName: UILabel = {
        let label = UILabel()
        label.text = "Display Full Name"
        return label
    }()
    
    lazy var emailControl: UISegmentedControl = {
        let items = ["Public", "Friends"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(EventView.indexChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var phoneNumberControl: UISegmentedControl = {
        let items = ["Public", "Friends"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(EventView.indexChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var fullNameControl: UISegmentedControl = {
        let items = ["Public", "Friends"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(EventView.indexChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addEmailLabel() {
        addSubview(displayEmail)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayEmail.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            displayEmail.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            displayEmail.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            displayEmail.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4)
            ])
    }
    
    private func addPhoneNumberLabel() {
        addSubview(displayPhoneNumber)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayPhoneNumber.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            displayPhoneNumber.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            displayEmail.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            displayEmail.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4)
            ])
    }
    
    
    @objc func emailSettingChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
   print("hi")
        case 1:
            print("yo")
        default:
            break
        }
    }
    
}
