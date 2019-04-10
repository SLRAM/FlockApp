//
//  CreateEditView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
protocol CreateViewDelegate: AnyObject {
    func createPressed()
    func addressPressed()
    func datePressed()
    func trackingPressed()
    func friendsPressed()
}
class CreateEditView: UIView {
    
    weak var delegate: CreateViewDelegate?
    
    
    lazy var addressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Event Address", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(addressPressed), for: .touchUpInside)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func addressPressed() {
        delegate?.addressPressed()
        print("event address pressed")
        
    }
    
    lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Event Date", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(datePressed), for: .touchUpInside)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func datePressed() {
        delegate?.datePressed()
        print("event date pressed")
        
    }
    
    lazy var trackingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Event Tracking Time", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(trackingPressed), for: .touchUpInside)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func trackingPressed() {
        delegate?.trackingPressed()
        print("event date pressed")
        
    }
    lazy var friendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Friends", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(friendsPressed), for: .touchUpInside)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func friendsPressed() {
        delegate?.friendsPressed()
        print("event date pressed")
        
    }
    
    
    
    
    
    
    
    public lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Create", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createPressed))
        return button
    }()
    @objc func createPressed() {
        delegate?.createPressed()
    }
    
    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10.0
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = #colorLiteral(red: 0.8529050946, green: 0.8478356004, blue: 0.8568023443, alpha: 0.4653253425).cgColor
        textView.textColor = .gray
        textView.textAlignment = .center
//        textView.font = textView.font?.withSize(20)
        textView.text = "Enter the Event Title"
        textView.tag = 0
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .white
        setupView()
    }
    
}
extension CreateEditView {
    func setupView() {
        setupTitleTextField()
        setupAddressButton()
        setupDateButton()
        setupTrackingButton()
        setupFriendButton()

    }
    func setupTitleTextField() {
        addSubview(titleTextView)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        titleTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    func setupAddressButton() {
        addSubview(addressButton)
        addressButton.translatesAutoresizingMaskIntoConstraints = false
        addressButton.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10).isActive = true
        addressButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        addressButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        addressButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }

    func setupDateButton() {
        addSubview(dateButton)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.topAnchor.constraint(equalTo: addressButton.bottomAnchor, constant: 10).isActive = true
        dateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        dateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        dateButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    func setupTrackingButton() {
        addSubview(trackingButton)
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        trackingButton.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 10).isActive = true
        trackingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        trackingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        trackingButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    func setupFriendButton() {
        addSubview(friendButton)
        friendButton.translatesAutoresizingMaskIntoConstraints = false
        friendButton.topAnchor.constraint(equalTo: trackingButton.bottomAnchor, constant: 10).isActive = true
        friendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        friendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        friendButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
}
