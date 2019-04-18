//
//  SettingsView.swift
//  FlockApp
//
//  Created by Biron Su on 4/11/19.
//

import UIKit

class SettingsView: UIView {
    
    //display email, number, full name between public and friends
    
    lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        return button
    }()

    lazy var displayEmail: UILabel = {
       let label = UILabel()
        label.text = "Display Email"
        return label
    }()
    
    lazy var displayPhoneNumber: UILabel = {
        let label = UILabel()
        label.text = "Display Phone #"
        label.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
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
        self.backgroundColor = .white
        addEmailLabel()
        addPhoneNumberLabel()
        addFullNameLabel()
        addEmailControl()
        addPhoneNumberControl()
        addFullNameControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addEmailLabel() {
        addSubview(displayEmail)
        displayEmail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayEmail.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            displayEmail.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -90),
            displayEmail.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            displayEmail.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4)
            ])
    }
    
    private func addPhoneNumberLabel() {
        addSubview(displayPhoneNumber)
        displayPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayPhoneNumber.topAnchor.constraint(equalTo: displayEmail.bottomAnchor, constant: 10),
            displayPhoneNumber.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -90),
            displayPhoneNumber.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            displayPhoneNumber.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4)
            ])
    }
    
    private func addFullNameLabel() {
        addSubview(displayFullName)
        displayFullName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayFullName.topAnchor.constraint(equalTo: displayPhoneNumber.bottomAnchor, constant: 10),
            displayFullName.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -90),
            displayFullName.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            displayFullName.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4)
            ])
    }
    
    private func addEmailControl() {
        addSubview(emailControl)
        emailControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            emailControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 90),
            emailControl.heightAnchor.constraint(equalTo: displayEmail.heightAnchor),
            emailControl.widthAnchor.constraint(equalTo: displayEmail.widthAnchor)
            ])
    }
    
    private func addPhoneNumberControl() {
        addSubview(phoneNumberControl)
        phoneNumberControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneNumberControl.topAnchor.constraint(equalTo: emailControl.bottomAnchor, constant: 10),
            phoneNumberControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 90),
            phoneNumberControl.heightAnchor.constraint(equalTo: displayPhoneNumber.heightAnchor),
            phoneNumberControl.widthAnchor.constraint(equalTo: displayPhoneNumber.widthAnchor)
            ])
    }
    
    private func addFullNameControl() {
        addSubview(fullNameControl)
        fullNameControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fullNameControl.topAnchor.constraint(equalTo: phoneNumberControl.bottomAnchor, constant: 10),
            fullNameControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 90),
            fullNameControl.heightAnchor.constraint(equalTo: displayFullName.heightAnchor),
            fullNameControl.widthAnchor.constraint(equalTo: displayFullName.widthAnchor)
            ])
    }
    
    
//    @objc func emailSettingChanged(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//        case 0:
//
//        case 1:
//            print("yo")
//        default:
//            break
//        }
//    }
//
//    @objc func phoneNumberSettingChanged(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//        case 0:
//            print("hi")
//        case 1:
//            print("yo")
//        default:
//            break
//        }
//    }
//
//    @objc func fullNameSettingChanged(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//        case 0:
//            print("hi")
//        case 1:
//            print("yo")
//        default:
//            break
//        }
//    }
    
}
