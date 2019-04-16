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
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Current Events", "Past Events"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor =  #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//        segmentedControl.layer.borderWidth = 2
        //segmentedControl.layer.opacity = 0.3
        segmentedControl.layer.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    

        public lazy var currentEventsButton: UISegmentedControl = {
            let button = UISegmentedControl()
            button.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
            return button
        }()
    
        public lazy var pastEventsButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            button.setTitle("Join", for: .normal)
            return button
        }()
    
        public lazy var collectionView: UICollectionView = {
            let cellLayout = UICollectionViewFlowLayout()
            cellLayout.scrollDirection = .vertical
            cellLayout.sectionInset = UIEdgeInsets.init(top: 16, left: 5, bottom: 16, right: 20)
            cellLayout.itemSize = CGSize.init(width: 375, height:200)
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
            collectionView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
            self.collectionView.register(EventHomeCollectionViewCell.self, forCellWithReuseIdentifier: "EventHomeCollectionViewCell")
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
          
    
        }
    
        private func commonInit() {
            setConstraints()
        }
    
        func setConstraints() {
            setupMyViewTwo()
            setupMyView()
           // setupCreateButton()
           // setupJoinButton()
            setupCollectionView()
            setupSegmentedView()
    
        }
    
    private func setupSegmentedView(){
        addSubview(segmentedControl)
        
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.04).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7).isActive = true
    
        
        
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
    func setupCreateButton() {
        addSubview(currentEventsButton)
        currentEventsButton.translatesAutoresizingMaskIntoConstraints = false
        
        currentEventsButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        currentEventsButton.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.5).isActive = true
        currentEventsButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        currentEventsButton.topAnchor.constraint(equalTo: myView.topAnchor).isActive = true

    }
    func setupJoinButton() {
        addSubview(pastEventsButton)
        pastEventsButton.translatesAutoresizingMaskIntoConstraints = false
        pastEventsButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        pastEventsButton.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.5).isActive = true
        pastEventsButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        pastEventsButton.bottomAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true
    }
    func setupCollectionView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
         collectionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.85).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
    @objc func indexChanged(_ sender: UISegmentedControl){
//        switch sender.selectedSegmentIndex {
//        case 0:
//            print("Current Events")
//
//        }
    }
    
}










