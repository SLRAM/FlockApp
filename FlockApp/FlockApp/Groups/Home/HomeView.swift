//
//  HomeView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit


class HomeView: UIView {

        public lazy var createButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
            button.setTitle("Create", for: .normal)
            return button
        }()
    
        public lazy var joinButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            button.setTitle("Join", for: .normal)
            return button
        }()
    
        public lazy var collectionView: UICollectionView = {
            let cellLayout = UICollectionViewFlowLayout()
            cellLayout.scrollDirection = .vertical
            cellLayout.sectionInset = UIEdgeInsets.init(top: 16, left: 5, bottom: 16, right: 5)
            cellLayout.itemSize = CGSize.init(width: 375, height:225)
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
            collectionView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            collectionView.layer.cornerRadius = 15.0
            return collectionView
        }()
    
    lazy var myView: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        return view
    }()
    lazy var myViewTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
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
            setupCreateButton()
            setupJoinButton()
            setupCollectionView()
    
        }
    func setupMyViewTwo() {
        addSubview(myViewTwo)
        myViewTwo.translatesAutoresizingMaskIntoConstraints = false
        myViewTwo.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        myViewTwo.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        myViewTwo.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        myViewTwo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    }
    func setupMyView() {
        addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        myView.heightAnchor.constraint(equalTo: myViewTwo.heightAnchor, multiplier: 0.4).isActive = true
        myView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        myView.centerYAnchor.constraint(equalTo: myViewTwo.centerYAnchor).isActive = true
    }
    func setupCreateButton() {
        addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        createButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        createButton.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.5).isActive = true
        createButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        createButton.topAnchor.constraint(equalTo: myView.topAnchor).isActive = true

    }
    func setupJoinButton() {
        addSubview(joinButton)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        joinButton.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.5).isActive = true
        joinButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        joinButton.bottomAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true
    }
    func setupCollectionView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
         collectionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
}










