//
//  HomeCollectionViewCell.swift
//  FlockApp
//
//  Created by Yaz Burrell on 4/10/19.
//

import UIKit
import CoreMotion

protocol EventHomeCollectionViewCellDelegate: AnyObject {
    func acceptedPressed(tag: Int)
    func declinePressed(tag: Int)
}

class EventHomeCollectionViewCell: UICollectionViewCell {
    weak var delegate: EventHomeCollectionViewCellDelegate?
    
    //var homeView = HomeView()
    
    public lazy var eventLabel: UILabel = {
        let label = UILabel()
        let fontSize: CGFloat = 30
        label.text = "Event #1"
        label.textColor = .black
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 30), size: 30)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        
        //label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        return label
    }()
    
    public lazy var startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Monday"
        //label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.textColor = .black
        return label
    }()
    
    public lazy var eventImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "quickEvent"))
        image.clipsToBounds = true
        image.layer.cornerRadius = 14
        return image
    }()
    
    public lazy var joinEventButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "alert")
        button.frame = CGRect.init(x: 10, y: 20, width: 80, height: 80)
        button.setImage(image, for: .normal)
        return button
    }()
    
    public lazy var invitedByLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var goingButton: UIButton = {
        let button = UIButton(type:UIButton.ButtonType.custom)
        button.addTarget(self, action: #selector(eventAcceptedPressed), for: .touchUpInside)
        let image = UIImage(named: "check")
        button.frame = CGRect.init(x: 10, y: 20, width: 40, height: 40)
        button.setImage(image, for: .normal)
        return button
    }()
    
    @objc func eventAcceptedPressed(_ sender: UIButton) {
        delegate?.acceptedPressed(tag: sender.tag)
    }
    
    public lazy var declineButton: UIButton = {
        let button = UIButton(type:UIButton.ButtonType.custom)
        let image = UIImage(named: "delete")
        button.addTarget(self, action: #selector(declineEventPressed), for: .touchUpInside)
        button.frame = CGRect.init(x: 10, y: 20, width: 40, height: 40)
        button.setImage(image, for: .normal)
        return button
    }()
    
    @objc func declineEventPressed(_ sender: UIButton){
        delegate?.declinePressed(tag: sender.tag)
    }
    
    func setupEventLabel(){
      addSubview(eventLabel)
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        eventLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -130).isActive = true
        eventLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        eventLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        eventLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
    }
    
    func setupEventDay(){
        addSubview(startDateLabel)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -95).isActive = true
        startDateLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -37).isActive = true
        startDateLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7).isActive = true
        startDateLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupImage(){
        addSubview(eventImage)
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        eventImage.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
        eventImage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        eventImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        eventImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    func setupJoinButton(){
        addSubview(joinEventButton)
        joinEventButton.translatesAutoresizingMaskIntoConstraints = false
        joinEventButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -168).isActive = true
        joinEventButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 174).isActive = true
        joinEventButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.10).isActive = true
        joinEventButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.10).isActive = true
    }
    
    func setupAcceptButton(){
        addSubview(goingButton)
        goingButton.translatesAutoresizingMaskIntoConstraints = false
        goingButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 143).isActive = true
        goingButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 100).isActive = true
        goingButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.09).isActive = true
        goingButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.09).isActive = true
    }
    
    func setupDeclineButton(){
        addSubview(declineButton)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 143).isActive = true
        declineButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 150).isActive = true
        declineButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.09).isActive = true
        declineButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.09).isActive = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        setupImage()
        setupJoinButton()
        setupEventLabel()
        setupEventDay()
        setupAcceptButton()
        setupDeclineButton()
        
        
    }
    
    

    
    
    
    
}


