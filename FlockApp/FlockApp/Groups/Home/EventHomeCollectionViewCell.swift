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
}

class EventHomeCollectionViewCell: UICollectionViewCell {
    weak var delegate: EventHomeCollectionViewCellDelegate?
    
    //var homeView = HomeView()
    
    public lazy var eventLabel: UILabel = {
        let label = UILabel()
        label.text = "Event #1"
//        label.backgroundColor = .white
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)

        label.textColor = .black
        return label
    }()
    
    public lazy var startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Monday"
//        label.backgroundColor = .white
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)

        label.textColor = .black
        return label
    }()
    
    public lazy var eventImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "pitons"))
        image.clipsToBounds = true
        image.layer.cornerRadius = 14
        return image
    }()
    
    public lazy var joinEventButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "notification")
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
        let image = UIImage(named: "accept")
        button.frame = CGRect.init(x: 10, y: 20, width: 40, height: 40)
        button.setImage(image, for: .normal)
        return button
    }()
    
    @objc func eventAcceptedPressed(_ sender: UIButton) {
        delegate?.acceptedPressed(tag: sender.tag)
    }
    
    public lazy var declineButton: UIButton = {
        let button = UIButton(type:UIButton.ButtonType.custom)
        let image = UIImage(named: "decline")
        button.frame = CGRect.init(x: 10, y: 20, width: 40, height: 40)
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    private let motionManager = CMMotionManager()
    private weak var shadowView: UIView?
    private static let kInnerMargin: CGFloat = 20.0
    
    private func configureShadowView(){
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: EventHomeCollectionViewCell.kInnerMargin, y: EventHomeCollectionViewCell.kInnerMargin, width: bounds.width - (2 * EventHomeCollectionViewCell.kInnerMargin), height: bounds.height - ( 2 * EventHomeCollectionViewCell.kInnerMargin )))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView

        if motionManager.isDeviceMotionActive {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
                if let motion = motion {
                    let pitch = motion.attitude.pitch * 10
                    let roll = motion.attitude.roll * 10
                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
                }
            })
        }
    }
    
    func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.35
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
    

    

    func setupEventLabel(){
      addSubview(eventLabel)
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        eventLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 100).isActive = true
        eventLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        eventLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        eventLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
    }
    
    func setupEventDay(){
        addSubview(startDateLabel)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 150).isActive = true
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
        configureShadowView()
        //setupPendingJoinEvents()
        
        
    }
    
    
}


//two buttons with custom images for two different events
