//
//  QuickEventTableView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 9/3/19.
//

import UIKit

protocol QuickEventTableViewDelegate: AnyObject {
    func createQuickPressed()
    func friendsQuickPressed()
    func cancelQuickPressed()
    func quickTrackingIncrease()
    func quickTrackingDecrease()
    func quickProximityIncrease()
    func quickProximityDecrease()
}
class QuickEventTableView: UIView {
    
    weak var delegate: QuickEventTableViewDelegate?
    
    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.8923556805, green: 0.9023317695, blue: 0.9020053744, alpha: 1)
        label.text = "Event Tracking Time"
        label.textAlignment = .center
        label.textColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        label.layer.cornerRadius = 10.0

        label.layer.masksToBounds = true

        return label
    }()
    
    lazy var trackingIncreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(quickTrackingIncrease), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func quickTrackingIncrease() {
        delegate?.quickTrackingIncrease()
        
    }
    lazy var trackingDecreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(quickTrackingDecrease), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func quickTrackingDecrease() {
        delegate?.quickTrackingDecrease()
        
    }
    lazy var myProximityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.8923556805, green: 0.9023317695, blue: 0.9020053744, alpha: 1)
        label.text = "Proximity Distance"
        label.textAlignment = .center
        label.textColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true

        return label
    }()
    
    lazy var proximityIncreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(quickProximityIncrease), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func quickProximityIncrease() {
        delegate?.quickProximityIncrease()
        
    }
    lazy var proximityDecreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(quickProximityDecrease), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func quickProximityDecrease() {
        delegate?.quickProximityDecrease()
        
    }
    
    lazy var friendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Friends", for: .normal)
        button.setTitleColor(UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(friendsQuickPressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8923556805, green: 0.9023317695, blue: 0.9020053744, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func friendsQuickPressed() {
        delegate?.friendsQuickPressed()
        print("event date pressed")
        
    }
    public lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed))
        return button
    }()
    @objc func cancelButtonPressed() {
        delegate?.cancelQuickPressed()
    }
    
    public lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Create", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createQuickPressed))
        return button
    }()
    @objc func createQuickPressed() {
        delegate?.createQuickPressed()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = #colorLiteral(red: 0.9665842652, green: 0.9562553763, blue: 0.9781278968, alpha: 1)
        setupView()
    }
    
}
extension QuickEventTableView {
    func setupView() {
        setupTracking()
        setupProximity()
        setupFriendButton()        
    }
    func setupTracking() {
        addSubview(myLabel)
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        myLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.26).isActive = true
        
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
    
    
    func setupProximity() {
        addSubview(myProximityLabel)
        myProximityLabel.translatesAutoresizingMaskIntoConstraints = false
        myProximityLabel.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 10).isActive = true
        myProximityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        myProximityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        myProximityLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.26).isActive = true
        
        setupProximityIncrease()
        setupProximityDecrease()
    }
    func setupProximityIncrease() {
        addSubview(proximityIncreaseButton)
        proximityIncreaseButton.translatesAutoresizingMaskIntoConstraints = false
        proximityIncreaseButton.topAnchor.constraint(equalTo: myProximityLabel.topAnchor).isActive = true
        proximityIncreaseButton.trailingAnchor.constraint(equalTo: myProximityLabel.trailingAnchor).isActive = true
        proximityIncreaseButton.heightAnchor.constraint(equalTo: myProximityLabel.heightAnchor, multiplier: 1).isActive = true
        proximityIncreaseButton.widthAnchor.constraint(equalTo: myProximityLabel.widthAnchor, multiplier: 0.2).isActive = true
    }
    func setupProximityDecrease() {
        addSubview(proximityDecreaseButton)
        proximityDecreaseButton.translatesAutoresizingMaskIntoConstraints = false
        proximityDecreaseButton.topAnchor.constraint(equalTo: myProximityLabel.topAnchor).isActive = true
        proximityDecreaseButton.leadingAnchor.constraint(equalTo: myProximityLabel.leadingAnchor).isActive = true
        proximityDecreaseButton.heightAnchor.constraint(equalTo: myProximityLabel.heightAnchor, multiplier: 1).isActive = true
        proximityDecreaseButton.widthAnchor.constraint(equalTo: myProximityLabel.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    
    func setupFriendButton() {
        addSubview(friendButton)
        friendButton.translatesAutoresizingMaskIntoConstraints = false
        friendButton.topAnchor.constraint(equalTo: myProximityLabel.bottomAnchor, constant: 10).isActive = true
        friendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        friendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        friendButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.26).isActive = true
    }

}
