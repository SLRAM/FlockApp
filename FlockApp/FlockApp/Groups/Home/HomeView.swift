//
//  HomeView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

protocol UserEventCollectionViewDelegate: AnyObject {
    func segmentedUserEventsPressed()
    func segmentedPastEventPressed()
    func joinEventPressed()

}

class HomeView: UIView {
    
    weak var delegate: UserEventCollectionViewDelegate?
    
    var homeViewController: HomeViewController?

    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Thursday, 18th, 2019"
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 12), size: 12)
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Thursday"
        label.backgroundColor = .white
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 40), size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 35)
        return label
    }()
    
    lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let image = UIImage(named: "createButton")
        print("Create button pressed")
        return button
    }()
    
    
    

    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Current Events", "Past Events", "Join"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor =  .black
        segmentedControl.backgroundColor = #colorLiteral(red: 0.9101855159, green: 0.2931141555, blue: 1, alpha: 1)
        segmentedControl.layer.borderWidth = 0.1
        //segmentedControl.layer.opacity = 0.3
        segmentedControl.layer.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        return segmentedControl
    }()
    
        public lazy var usersCollectionView: UICollectionView = {
            let cellLayout = UICollectionViewFlowLayout()
            cellLayout.scrollDirection = .vertical
            cellLayout.sectionInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 25)
            cellLayout.itemSize = CGSize.init(width: 350, height:350)
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
            collectionView.backgroundColor = .white
            collectionView.layer.cornerRadius = 15.0
            return collectionView
        }()
    
    
    lazy var myView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var myViewTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
            //setupMyViewTwo()
            //setupMyView()
            setUpDateLabel()
            setUpDayLabel()
           // setUpCreateButton()
            setupUsersCollectionView()
            setupSegmentedView()
            
           
            
            
    
        }
    
    func setUpDateLabel(){
       addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.02).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        //dateLabel.bottomAnchor.constraint(equalTo: usersCollectionView.topAnchor, constant: 0).isActive = true
        
    }
    
    func setUpDayLabel() {
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        dayLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
        dayLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        
    }
    
    
//    func setUpCreateButton(){
//        addSubview(createButton)
//        createButton.translatesAutoresizingMaskIntoConstraints = false
//        createButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
//        createButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 170).isActive = true
//        createButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.04).isActive = true
//        createButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.07).isActive = true
//    }
    
    
    private func setupSegmentedView(){
        addSubview(segmentedControl)
        
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant:
            125).isActive = true
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
    
    func setupMyViewTwo() {
        addSubview(myViewTwo)
        myViewTwo.translatesAutoresizingMaskIntoConstraints = false
        myViewTwo.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        myViewTwo.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.9).isActive = true
        myViewTwo.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        myViewTwo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    }
    func setupMyView() {
        addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        myView.heightAnchor.constraint(equalTo: myViewTwo.heightAnchor, multiplier: 0.9).isActive = true
        myView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        myView.centerYAnchor.constraint(equalTo: myViewTwo.centerYAnchor).isActive = true
    }




       @objc func indexChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("Current Events")
            dateLabel.isHidden = false
            dayLabel.isHidden = false
            //createButton.isHidden = false
            segmentedControl.isHidden = false
            delegate?.segmentedUserEventsPressed()
    
        case 1:
            print("Past Event")
            dateLabel.isHidden = false
            dayLabel.isHidden = false
            segmentedControl.isHidden = false
            delegate?.segmentedPastEventPressed()
            usersCollectionView.isHidden = false
         
        case 2:
            print("Join Event")
            dateLabel.isHidden = false
            dayLabel.isHidden = false
            segmentedControl.isHidden = false
            usersCollectionView.isHidden = false
            
        default:
            break
        }
    }
    
    }










