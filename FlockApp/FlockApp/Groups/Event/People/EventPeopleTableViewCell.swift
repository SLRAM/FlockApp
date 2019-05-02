//
//  EventPeopleTableViewCell.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

class EventPeopleTableViewCell: UITableViewCell {

    public lazy var profilePicture: CircularImageView = {
       let image = CircularImageView()
       return image
    }()
    
    public lazy var nameLabel:  UILabel = {
        let label = UILabel()
        label.text = "Name here"
        label.textColor = .black
        return label
    }()

    public lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Task here"
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        setupImageView()
    }
    
    func setupImageView() {
        addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            profilePicture.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            profilePicture.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            profilePicture.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25)
            ])
        
    }
    



}
