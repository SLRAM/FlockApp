//
//  HomeCollectionViewCell.swift
//  FlockApp
//
//  Created by Yaz Burrell on 4/10/19.
//

import UIKit

class EventHomeCollectionViewCell: UICollectionViewCell {
    
    public lazy var eventLabel: UILabel = {
        let label = UILabel()
        label.text = "Event #1"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    public lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Monday"
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    public lazy var eventImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "flock"))
        //image.contentMode = .scaleAspectFill
        return image
    }()
    
    func setupEventLabel(){
      addSubview(eventLabel)
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        eventLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 50).isActive = true
        eventLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        eventLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        eventLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
    }
    
    func setupEventDay(){
        addSubview(dayLabel)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupImage(){
        addSubview(eventImage)
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        eventImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        eventImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        eventImage.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
        eventImage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
    
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
        setupEventLabel()
       // setupImage()
        
    }
    
    
}
