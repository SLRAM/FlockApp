//
//  ProfileView.swift
//  FlockApp
//
//  Created by Biron Su on 4/11/19.
//

import UIKit

class ProfileView: UIView {

    lazy var displayNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "DisplayName"
        textView.textAlignment = .center
        textView.layer.cornerRadius = 10.0
        textView.backgroundColor = UIColor(white: 1, alpha: 0.5)

        return textView
    }()
    lazy var fullNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "Full Name"
        return textView
    }()
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name :"
        label.textColor = .black
        return label
    }()
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-mail :"
        label.textColor = .black
        return label
    }()
    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone :"
        label.textColor = .black
        return label
    }()
    lazy var firstNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    lazy var lastNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    lazy var imageButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(named: "ProfileImage"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    lazy var emailTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    lazy var phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "Phone number: N/A"
        return textView
    }()
    lazy var editButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        return button
    }()
    lazy var signOutButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(" Sign Out ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        return button
    }()
    lazy var addFriend: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(" Add Friend ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        return button
    }()
    lazy var blockButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(" Block User ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        return button
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
        setupEditButton()
        setupImageButton()
        setupDisplayNameTextView()
        setupFullNameTextView()
        setupEmailTextView()
        setupPhoneTextView()
        setupAddButton()
        setupSignOutButton()
        setupBlockButton()
    }

    private func setupEditButton() {
        addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 50)
            ])
    }
    private func setupImageButton() {
        addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            imageButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            imageButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4)
            ])
    }
    private func setupDisplayNameTextView() {
        addSubview(displayNameTextView)
        displayNameTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayNameTextView.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: -40),
            displayNameTextView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            displayNameTextView.widthAnchor.constraint(equalToConstant: 300),
            displayNameTextView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    private func setupFullNameTextView() {
        addSubview(fullNameLabel)
        addSubview(firstNameTextView)
        addSubview(lastNameTextView)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextView.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: displayNameTextView.bottomAnchor, constant: 30),
            fullNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            fullNameLabel.widthAnchor.constraint(equalToConstant: 60),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 30),
            firstNameTextView.topAnchor.constraint(equalTo: displayNameTextView.bottomAnchor, constant: 30),
            firstNameTextView.leadingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            firstNameTextView.widthAnchor.constraint(equalToConstant: 150),
            firstNameTextView.heightAnchor.constraint(equalToConstant: 30),
            lastNameTextView.topAnchor.constraint(equalTo: displayNameTextView.bottomAnchor, constant: 30),
            lastNameTextView.leadingAnchor.constraint(equalTo: firstNameTextView.trailingAnchor),
            lastNameTextView.widthAnchor.constraint(equalToConstant: 75),
            lastNameTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupEmailTextView() {
        addSubview(emailLabel)
        addSubview(emailTextView)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailLabel.heightAnchor.constraint(equalToConstant: 30),
            emailLabel.widthAnchor.constraint(equalToConstant: 60),
            emailTextView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 30),
            emailTextView.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailTextView.widthAnchor.constraint(equalToConstant: 300),
            emailTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupPhoneTextView() {
        addSubview(phoneNumberLabel)
        addSubview(phoneNumberTextView)
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneNumberLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            phoneNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            phoneNumberLabel.heightAnchor.constraint(equalToConstant: 30),
            phoneNumberTextView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30),
            phoneNumberTextView.leadingAnchor.constraint(equalTo: phoneNumberLabel.trailingAnchor),
            phoneNumberTextView.widthAnchor.constraint(equalToConstant: 300),
            phoneNumberTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupAddButton() {
        addSubview(addFriend)
        addFriend.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addFriend.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            addFriend.topAnchor.constraint(equalTo: phoneNumberTextView.bottomAnchor, constant: 20),
            addFriend.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupBlockButton() {
        addSubview(blockButton)
        blockButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blockButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            blockButton.topAnchor.constraint(equalTo: addFriend.bottomAnchor, constant: 20),
            blockButton.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupSignOutButton() {
        addSubview(signOutButton)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: phoneNumberTextView.bottomAnchor, constant: 20),
            signOutButton.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
}
