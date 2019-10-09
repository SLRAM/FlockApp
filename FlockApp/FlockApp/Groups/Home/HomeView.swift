//
//  HomeView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

protocol UserEventCollectionViewDelegate: AnyObject {
    func segmentedEventsPressed()
    func segmentedPastEventPressed()
    func pendingJoinEventPressed()
}

class HomeView: UIView {
    weak var delegate: UserEventCollectionViewDelegate?
    var homeViewController: HomeViewController?
    var cellView =  EventHomeCollectionViewCell()

    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Thursday, 18th, 2019"
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 12), size: 12)
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 40), size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 40)//letters too big for space
        return label
    }()
    
    lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let image = UIImage(named: "createButton")
        print("Create button pressed")
        return button
    }()
    
    lazy var notificationIndicator: UIImageView = {
        let image = UIImageView(image: UIImage(named: "reddot"))
        image.clipsToBounds = true
        image.isHidden = true
        return image
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Events", "Past", "Pending"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.tintColor = #colorLiteral(red: 0.5921568627, green: 0.02352941176, blue: 0.737254902, alpha: 1)
        segmentedControl.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        segmentedControl.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.02352941176, blue: 0.737254902, alpha: 1)
        return segmentedControl
    }()
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
     self.delegate?.segmentedPastEventPressed()
                case UISwipeGestureRecognizer.Direction.right:
        self.delegate?.pendingJoinEventPressed()
            default:
                break
            }
        }
    }
    
        public lazy var usersCollectionView: UICollectionView = {
            let cellLayout = UICollectionViewFlowLayout()
            cellLayout.scrollDirection = .vertical
            cellLayout.sectionInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 10, right: 25)
            cellLayout.minimumLineSpacing = 30
            cellLayout.itemSize = CGSize.init(width: 350, height:350)
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
            collectionView.backgroundColor = #colorLiteral(red: 0.9665842652, green: 0.9562553763, blue: 0.9781278968, alpha: 1)
            collectionView.layer.cornerRadius = 15.0
            return collectionView
        }()
    
        override init(frame: CGRect) {
            super.init(frame: UIScreen.main.bounds)
            commonInit()
            self.usersCollectionView.register(EventHomeCollectionViewCell.self, forCellWithReuseIdentifier: "EventHomeCollectionViewCell")
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
        private func commonInit() {

            setConstraints()
        }
    
        func setConstraints() {
            setUpDateLabel()
            setUpDayLabel()
            setupUsersCollectionView()
            setupSegmentedView()
            setupNotification()
        }
    
    func setUpDateLabel(){
       addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.02).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    func setUpDayLabel() {
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        dayLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.09).isActive = true
        dayLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setupNotification(){
        // need to fix location last
        addSubview(notificationIndicator)
        notificationIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notificationIndicator.topAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -5),
            notificationIndicator.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor, constant: 5),
            notificationIndicator.heightAnchor.constraint(equalToConstant: 12.5),
            notificationIndicator.widthAnchor.constraint(equalToConstant: 12.5)
            ])
    }
    
    func setupSegmentedView(){
    addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 88).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.04).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func setupUsersCollectionView() {
        addSubview(usersCollectionView)
        usersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        usersCollectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        usersCollectionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.80).isActive = true
        usersCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        usersCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
