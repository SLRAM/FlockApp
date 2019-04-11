//
//  ProfileView.swift
//  FlockApp
//
//  Created by Biron Su on 4/11/19.
//

import UIKit

class ProfileView: UIView {

    lazy var displayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "DisplayName"
        label.textAlignment = .center
        label.layer.cornerRadius = 10.0
        label.layer.borderWidth = 1.0
        label.backgroundColor = UIColor(white: 1, alpha: 0.5)

        return label
    }()
    lazy var imageButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .gray
        return button
    }()
    lazy var emailTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "WheresMyName@missingname.com"
        return textView
    }()
    lazy var phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "555-5555"
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
        setupDisplayNameLabel()
        setupEmailTextView()
        setupPhoneTextView()
        
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
    private func setupDisplayNameLabel() {
        addSubview(displayNameLabel)
        displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayNameLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: -10),
            displayNameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            displayNameLabel.widthAnchor.constraint(equalToConstant: 300),
            displayNameLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupEmailTextView() {
        addSubview(emailTextView)
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextView.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 30),
            emailTextView.widthAnchor.constraint(equalToConstant: 300),
            emailTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupPhoneTextView() {
        addSubview(phoneNumberTextView)
        phoneNumberTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneNumberTextView.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 30),
            phoneNumberTextView.widthAnchor.constraint(equalToConstant: 300),
            phoneNumberTextView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    private func setupBioTextView() {
        addSubview(bioTextView)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            ])
    }
}
