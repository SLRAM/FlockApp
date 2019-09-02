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
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.backgroundColor = #colorLiteral(red: 0.5913429856, green: 0.1131442711, blue: 0.7193526626, alpha: 1)
        textView.textColor = .white

        return textView
    }()
    lazy var miniView: UIView = {
        let miniView = UIView()
        miniView.backgroundColor = #colorLiteral(red: 0.5913429856, green: 0.1131442711, blue: 0.7193526626, alpha: 1)
        miniView.layer.cornerRadius = 10.0
        return miniView
    }()

    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name  :"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .green
        return label
    }()
    lazy var fullNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.backgroundColor = .blue
        
        return textView
    }()
    
    lazy var firstNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.isHidden = true
        textView.isScrollEnabled = false
        textView.textColor = .white
        
        return textView
    }()
    
    lazy var lastNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isHidden = true
        textView.textColor = .white
        textView.isScrollEnabled = false
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        return textView
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-mail :"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .green


        return label
    }()
    
    lazy var emailTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.textColor = .white
        textView.isScrollEnabled = false
        
        //        textView.backgroundColor = .clear
        textView.backgroundColor = .blue
        
        return textView
    }()
    
    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone :"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .green


        return label
    }()
    
    lazy var phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "N/A"
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.textColor = .white
        textView.isScrollEnabled = false
        //        textView.backgroundColor = .clear
        textView.backgroundColor = .blue
        return textView
    }()

    lazy var imageButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(named: "ProfileImage"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()

    lazy var editButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5913429856, green: 0.1131442711, blue: 0.7193526626, alpha: 1)
        return button
    }()
    lazy var signOutButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(" Sign Out ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5913429856, green: 0.1131442711, blue: 0.7193526626, alpha: 1)
        return button
    }()
    lazy var addFriend: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(" Add Friend ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5913429856, green: 0.1131442711, blue: 0.7193526626, alpha: 1)
        return button
    }()
    lazy var blockButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(" Block User ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5913429856, green: 0.1131442711, blue: 0.7193526626, alpha: 1)
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
        backgroundColor = #colorLiteral(red: 0.9665842652, green: 0.9562553763, blue: 0.9781278968, alpha: 1)
        setupEditButton()
        setupImageButton()
        setupDisplayNameTextView()
        setupMiniView()
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
            displayNameTextView.topAnchor.constraint(equalTo: imageButton.bottomAnchor),
            displayNameTextView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            displayNameTextView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            displayNameTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.08)
            ])
    }
    private func setupMiniView() {
        addSubview(miniView)
        miniView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            miniView.topAnchor.constraint(equalTo: displayNameTextView.bottomAnchor, constant: 15),
            miniView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            miniView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            miniView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9)
            ])
    }
    private func setupFullNameTextView() {
        addSubview(fullNameLabel)
        addSubview(fullNameTextView)
        addSubview(firstNameTextView)
        addSubview(lastNameTextView)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameTextView.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextView.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: miniView.topAnchor, constant: 15),
            fullNameLabel.leadingAnchor.constraint(equalTo: miniView.leadingAnchor, constant: 10),
            fullNameLabel.widthAnchor.constraint(equalTo: miniView.widthAnchor, multiplier: 0.22),
            fullNameLabel.heightAnchor.constraint(equalTo: miniView.heightAnchor, multiplier: 0.2),
            
            
            
            
            
            
            fullNameTextView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 20),
            fullNameTextView.leadingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            fullNameTextView.widthAnchor.constraint(equalToConstant: 200),
            fullNameTextView.heightAnchor.constraint(equalToConstant: 30),
            firstNameTextView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 25),
            firstNameTextView.leadingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            firstNameTextView.widthAnchor.constraint(equalToConstant: 100),
            firstNameTextView.heightAnchor.constraint(equalToConstant: 30),
            lastNameTextView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 25),
            lastNameTextView.leadingAnchor.constraint(equalTo: firstNameTextView.trailingAnchor),
            lastNameTextView.widthAnchor.constraint(equalToConstant: 100),
            lastNameTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupEmailTextView() {
        addSubview(emailLabel)
        addSubview(emailTextView)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            emailLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 20),
            emailLabel.centerYAnchor.constraint(equalTo: miniView.centerYAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: miniView.leadingAnchor, constant: 10),
            emailLabel.heightAnchor.constraint(equalTo: miniView.heightAnchor, multiplier: 0.2),
            emailLabel.widthAnchor.constraint(equalTo: miniView.widthAnchor, multiplier: 0.22),
            
            
            
            
            emailTextView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 15),
            emailTextView.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailTextView.widthAnchor.constraint(equalToConstant: 250),
            emailTextView.heightAnchor.constraint(equalTo: miniView.heightAnchor, multiplier: 0.2)
            ])
    }
    private func setupPhoneTextView() {
        addSubview(phoneNumberLabel)
        addSubview(phoneNumberTextView)
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneNumberLabel.bottomAnchor.constraint(equalTo: miniView.bottomAnchor, constant: -15),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: miniView.leadingAnchor, constant: 10),
            phoneNumberLabel.widthAnchor.constraint(equalTo: miniView.widthAnchor, multiplier: 0.22),
            phoneNumberLabel.heightAnchor.constraint(equalTo: miniView.heightAnchor, multiplier: 0.2),
            
            
            
            
            
            phoneNumberTextView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            phoneNumberTextView.leadingAnchor.constraint(equalTo: phoneNumberLabel.trailingAnchor),
            phoneNumberTextView.widthAnchor.constraint(equalToConstant: 200),
            phoneNumberTextView.heightAnchor.constraint(equalTo: miniView.heightAnchor, multiplier: 0.2)
            ])
    }
    private func setupAddButton() {
        addSubview(addFriend)
        addFriend.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addFriend.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            addFriend.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
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
            signOutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
            signOutButton.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
}
