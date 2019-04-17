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
    func cancelPressed()
}

class HomeView: UIView {
    
    weak var delegate: UserEventCollectionViewDelegate?
    
    var homeViewController: HomeViewController?
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Wednesday, 17th, 2019"
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 12), size: 12)
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Wednesday"
        label.backgroundColor = .white
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 40), size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        let image = UIImage(named: "createButton")
        button.frame = CGRect.init(x: -10, y: -20, width: 50, height: 45)
        button.setImage(image, for: .normal)

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
            cellLayout.sectionInset = UIEdgeInsets.init(top: 16, left: 5, bottom: 16, right: 20)
            cellLayout.itemSize = CGSize.init(width: 375, height:350)
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
            setUpCreateButton()
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
    
    
    func setUpCreateButton(){
        addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        createButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 170).isActive = true
        createButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.04).isActive = true
        createButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.07).isActive = true
    }
    
    
    private func setupSegmentedView(){
        addSubview(segmentedControl)
        
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant:
            135).isActive = true
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
//        switch sender.selectedSegmentIndex {
//        case 0:
//            print("Current Events")
//
//
//        }
//    }
    
    }

}








