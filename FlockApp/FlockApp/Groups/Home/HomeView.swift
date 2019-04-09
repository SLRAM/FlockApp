//
//  HomeView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import SnapKit

class HomeView: UIView {

    var createButton: UIButton!
    
    var joinButton: UIButton!
    
    var homePageBackground = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    
    var collectionView: UICollectionView!
    
    var collectionViewCell: UICollectionViewCell!
    
    
    func setUpCollectionView(){
        collectionView = UICollectionView()
        collectionViewCell = UICollectionViewCell()
        self.addSubview(collectionView)
        self.addSubview(collectionViewCell)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10).priority(750)
            make.right.equalTo(self).offset(-10).priority(750)
            make.bottom.equalTo(self).offset(20)
            
            make.width.lessThanOrEqualTo(500)
            
            
        }
        
    }
    
    func setUpCreateButton() {
        
    }
    
    func setUpJoinButton() {
        
    }
    


    
    


}










//    public lazy var createButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//        button.titleLabel?.text = "Create"
//        return button
//    }()
//
//    public lazy var joinButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//        button.titleLabel?.text = "Join"
//        return button
//    }()
//
//    public lazy var collectionView: UICollectionView = {
//        let cellLayout = UICollectionViewFlowLayout()
//        cellLayout.scrollDirection = .vertical
//        cellLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
//        cellLayout.itemSize = CGSize.init(width: 400, height: 400)
//        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
//        collectionView.backgroundColor = .white
//        collectionView.layer.isOpaque = true
//        collectionView.layer.cornerRadius = 15.0
//        return collectionView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: UIScreen.main.bounds)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//    }
//
//    private func commonInit() {
//        setConstraints()
//    }
//
//    func setConstraints() {
//        addSubview(createButton)
//        addSubview(joinButton)
//        addSubview(collectionView)
//    }
