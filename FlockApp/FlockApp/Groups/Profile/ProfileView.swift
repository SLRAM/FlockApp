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
        textView.layer.borderWidth = 1.0
        textView.backgroundColor = UIColor(white: 1, alpha: 0.5)

        return textView
    }()
    lazy var fullNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "Full Name"
        return textView
    }()
    lazy var firstNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "First Name"
        return textView
    }()
    lazy var lastNameTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "Last Name"
        return textView
    }()
    lazy var imageButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.setImage(UIImage(named: "ProfileImage"), for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = .gray
        button.layer.borderWidth = 1.0
        button.isUserInteractionEnabled = false
        return button
    }()
    lazy var emailTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "E-mail: WheresMyName@missingname.com"
        return textView
    }()
    lazy var phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "Phone number: 1(555)555-5555"
        return textView
    }()
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = """
        This is a Bio\n
        I like potato\n
        they go well with everything\n
        maybe except poptarts\n
        maybe... haven't tried.
        """
        return textView
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
        setupBioTextView()
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
            imageButton.heightAnchor.constraint(equalToConstant: 100),
            imageButton.widthAnchor.constraint(equalToConstant: 100)
            ])
    }
    private func setupDisplayNameTextView() {
        addSubview(displayNameTextView)
        displayNameTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayNameTextView.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: -10),
            displayNameTextView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            displayNameTextView.widthAnchor.constraint(equalToConstant: 300),
            displayNameTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupFullNameTextView() {
        addSubview(firstNameTextView)
        addSubview(lastNameTextView)
        firstNameTextView.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstNameTextView.topAnchor.constraint(equalTo: displayNameTextView.bottomAnchor, constant: 30),
            firstNameTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            firstNameTextView.widthAnchor.constraint(equalToConstant: 150),
            firstNameTextView.heightAnchor.constraint(equalToConstant: 30),
            lastNameTextView.topAnchor.constraint(equalTo: displayNameTextView.bottomAnchor, constant: 30),
            lastNameTextView.leadingAnchor.constraint(equalTo: firstNameTextView.trailingAnchor),
            lastNameTextView.widthAnchor.constraint(equalToConstant: 150),
            lastNameTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupEmailTextView() {
        addSubview(emailTextView)
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextView.topAnchor.constraint(equalTo: firstNameTextView.bottomAnchor, constant: 30),
            emailTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailTextView.widthAnchor.constraint(equalToConstant: 300),
            emailTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupPhoneTextView() {
        addSubview(phoneNumberTextView)
        phoneNumberTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneNumberTextView.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 30),
            phoneNumberTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            phoneNumberTextView.widthAnchor.constraint(equalToConstant: 300),
            phoneNumberTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupBioTextView() {
        addSubview(bioTextView)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bioTextView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            bioTextView.topAnchor.constraint(equalTo: phoneNumberTextView.bottomAnchor, constant: 20),
            bioTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            bioTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
            ])
    }
}
