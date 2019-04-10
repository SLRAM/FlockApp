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
            button.titleLabel?.text = "Create"
            button.setTitle("Create", for: .normal)
            return button
        }()
    
        public lazy var joinButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
            button.setTitle("join", for: .normal)
            return button
        }()
    
        public lazy var collectionView: UICollectionView = {
            let cellLayout = UICollectionViewFlowLayout()
            cellLayout.scrollDirection = .vertical
            cellLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
            cellLayout.itemSize = CGSize.init(width: 400, height: 400)
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
            collectionView.backgroundColor = .white
            collectionView.layer.isOpaque = true
            collectionView.layer.cornerRadius = 15.0
            return collectionView
        }()
    
    
    
        override init(frame: CGRect) {
            super.init(frame: UIScreen.main.bounds)
            commonInit()
            self.collectionView.register(EventHomeCollectionViewCell.self, forCellWithReuseIdentifier: "EventHomeCollectionViewCell")
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
    
        }
    
        private func commonInit() {
            setConstraints()
        }
    
        func setConstraints() {
            addSubview(createButton)
            addSubview(joinButton)
            addSubview(collectionView)
    
            createButton.translatesAutoresizingMaskIntoConstraints = false
            joinButton.translatesAutoresizingMaskIntoConstraints = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            createButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 230).isActive = true
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            createButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -580).isActive = true
            
            joinButton.topAnchor.constraint(equalTo: createButton.bottomAnchor , constant: 16).isActive = true
            joinButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            joinButton.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: -16).isActive = true
            joinButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -525).isActive = true
            
//            collectionView.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: 100).isActive = true
//            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
//            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
//            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
            
    
        }



    
    


}










