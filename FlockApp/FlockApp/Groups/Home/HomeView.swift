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
//        label.backgroundColor = .white
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)

        label.text = "Thursday, 18th, 2019"
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 12), size: 12)
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Thursday"
//        label.backgroundColor = .white
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)

        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 40), size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 45)
        return label
    }()
    
    lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let image = UIImage(named: "createButton")
        print("Create button pressed")
        return button
    }()
    

    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Events", "Past Events", "Pending Events"]
        let segmentedControl = UISegmentedControl(items: items)
        //segmentedControl.layer.borderColor = UIColor.clear.cgColor
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.tintColor =  .black
        segmentedControl.layer.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        //segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        return segmentedControl
    }()
    
        public lazy var usersCollectionView: UICollectionView = {
            let cellLayout = UICollectionViewFlowLayout()
            cellLayout.scrollDirection = .vertical
            cellLayout.sectionInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 25)
            cellLayout.itemSize = CGSize.init(width: 350, height:350)
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
            collectionView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9568627451, blue: 0.9764705882, alpha: 1)
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
            //cellView.setupEventLabel()
            //cellView.setupJoinButton()
        }
    
    func setUpDateLabel(){
       addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -68).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.02).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        //dateLabel.bottomAnchor.constraint(equalTo: usersCollectionView.topAnchor, constant: 0).isActive = true
        
    }
    
    func setUpDayLabel() {
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -70).isActive = true
        dayLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.08).isActive = true
        dayLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        
    }
    
    func setupSegmentedView(){
    addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -250).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.03).isActive = true
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










