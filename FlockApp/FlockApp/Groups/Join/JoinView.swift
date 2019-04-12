//
//  JoinView.swift
//  FlockApp
//
//  Created by Biron Su on 4/12/19.
//

import UIKit

class JoinView: UIView {

    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.alpha = 0.1
        return button
    }()
    lazy var middleCreateView: UIView = {
        let midView = UIView()
        midView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        midView.layer.cornerRadius = 10.0
        return midView
    }()
    lazy var eventIDTextView: UITextField = {
        let eventID = UITextField()
        eventID.placeholder = "Enter Event ID"
        eventID.layer.cornerRadius = 10.0
        return eventID
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Join", for: .normal)
        button.layer.cornerRadius = 10.0
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
        setupDismissButton()
        setupMiddleView()
        setupEventTextView()
        setupSendButton()
    }
    private func setupDismissButton() {
        addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dismissButton.widthAnchor.constraint(equalTo: self.widthAnchor),
            dismissButton.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
    }
    private func setupMiddleView() {
        addSubview(middleCreateView)
        middleCreateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            middleCreateView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            middleCreateView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            middleCreateView.heightAnchor.constraint(equalToConstant: 350),
            middleCreateView.widthAnchor.constraint(equalToConstant: 350)
            ])
    }
    private func setupEventTextView() {
        addSubview(eventIDTextView)
        eventIDTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventIDTextView.heightAnchor.constraint(equalToConstant: 40),
            eventIDTextView.leadingAnchor.constraint(equalTo: middleCreateView.leadingAnchor, constant: 20),
            eventIDTextView.trailingAnchor.constraint(equalTo: middleCreateView.trailingAnchor, constant: -20),
            eventIDTextView.topAnchor.constraint(equalTo: middleCreateView.topAnchor, constant: 80)
            ])
    }
    private func setupSendButton() {
        addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.leadingAnchor.constraint(equalTo: middleCreateView.leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: middleCreateView.trailingAnchor, constant: -20),
            sendButton.bottomAnchor.constraint(equalTo: middleCreateView.bottomAnchor, constant: -10)
            ])
    }
}
