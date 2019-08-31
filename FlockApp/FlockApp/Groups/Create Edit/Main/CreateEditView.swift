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
    func friendsPressed()
    func cancelPressed()
    func imagePressed()
    func trackingIncreasePressed()
    func trackingDecreasePressed()
}
class CreateEditView: UIView {
    
    weak var delegate: CreateViewDelegate?
    
    lazy var imageButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(imagePressed), for: .touchUpInside)
        button.backgroundColor = .clear
//        button.setBackgroundImage(UIImage(named: "quickEvent"), for: .normal)
        button.setImage(UIImage(named: "quickEvent"), for: .normal)
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10.0


        
//        collectionViewCell.contentView.layer.masksToBounds = true
//        collectionViewCell.backgroundColor = .clear // very important
//        collectionViewCell.layer.masksToBounds = false
//        collectionViewCell.layer.shadowOpacity = 0.25
//        collectionViewCell.layer.shadowRadius = 10
//        collectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        collectionViewCell.layer.shadowColor = UIColor.black.cgColor
//
//        let radius = button.layer.cornerRadius
//        button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: radius).cgPath
        
        
        
        
        
        return button
    }()
    @objc func imagePressed() {
        delegate?.imagePressed()
        print("event image pressed")
    }
    
    lazy var addressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Event Address", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(addressPressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8923556805, green: 0.9023317695, blue: 0.9020053744, alpha: 1)
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
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(datePressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8923556805, green: 0.9023317695, blue: 0.9020053744, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func datePressed() {
        delegate?.datePressed()
        print("event date pressed")
    }
    
    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.8923556805, green: 0.9023317695, blue: 0.9020053744, alpha: 1)
        label.text = "Event Tracking Time"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        return label
    }()
    
    lazy var trackingIncreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(trackingIncreasePressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func trackingIncreasePressed() {
        delegate?.trackingIncreasePressed()
    }
    lazy var trackingDecreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(trackingDecreasePressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func trackingDecreasePressed() {
        delegate?.trackingDecreasePressed()
    }
    lazy var friendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Friends", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(friendsPressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8923556805, green: 0.9023317695, blue: 0.9020053744, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func friendsPressed() {
        delegate?.friendsPressed()
    }
    
    lazy var myTableView: UITableView = {
        let tv = UITableView()
        tv.register(CreateEditTableViewCell.self, forCellReuseIdentifier: "CreateEditTableViewCell")
        tv.rowHeight = (UIScreen.main.bounds.width)/10
//        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()
    public lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed))
        return button
    }()
    @objc func cancelButtonPressed() {
        delegate?.cancelPressed()
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
        textView.font = UIFont.boldSystemFont(ofSize: 25)
        textView.tag = 0
        textView.text = "Enter the Event Title"
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
        setupImageButton()
        setupAddressButton()
        setupDateButton()
        setupTracking()
        setupFriendButton()
        setupTableView()
    }
    func setupTitleTextField() {
        addSubview(titleTextView)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        titleTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    func setupImageButton() {
        addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10).isActive = true
        imageButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.40).isActive = true
        imageButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.40).isActive = true
        imageButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    func setupAddressButton() {
        addSubview(addressButton)
        addressButton.translatesAutoresizingMaskIntoConstraints = false
        addressButton.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 10).isActive = true
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
    func setupTracking() {
        addSubview(myLabel)
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 10).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        myLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
        setupTrackingIncrease()
        setupTrackingDecrease()
    }
    func setupTrackingIncrease() {
        addSubview(trackingIncreaseButton)
        trackingIncreaseButton.translatesAutoresizingMaskIntoConstraints = false
        trackingIncreaseButton.topAnchor.constraint(equalTo: myLabel.topAnchor).isActive = true
        trackingIncreaseButton.trailingAnchor.constraint(equalTo: myLabel.trailingAnchor).isActive = true
        trackingIncreaseButton.heightAnchor.constraint(equalTo: myLabel.heightAnchor, multiplier: 1).isActive = true
        trackingIncreaseButton.widthAnchor.constraint(equalTo: myLabel.widthAnchor, multiplier: 0.2).isActive = true
    }
    func setupTrackingDecrease() {
        addSubview(trackingDecreaseButton)
        trackingDecreaseButton.translatesAutoresizingMaskIntoConstraints = false
        trackingDecreaseButton.topAnchor.constraint(equalTo: myLabel.topAnchor).isActive = true
        trackingDecreaseButton.leadingAnchor.constraint(equalTo: myLabel.leadingAnchor).isActive = true
        trackingDecreaseButton.heightAnchor.constraint(equalTo: myLabel.heightAnchor, multiplier: 1).isActive = true
        trackingDecreaseButton.widthAnchor.constraint(equalTo: myLabel.widthAnchor, multiplier: 0.2).isActive = true
    }
    func setupFriendButton() {
        addSubview(friendButton)
        friendButton.translatesAutoresizingMaskIntoConstraints = false
        friendButton.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 10).isActive = true
        friendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        friendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        friendButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    
    func setupTableView() {
        addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.topAnchor.constraint(equalTo: friendButton.bottomAnchor, constant: 10).isActive = true
        myTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
//        myTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
    }
}
