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
        setupNameLabel()
        setupTaskLabel()
    }
    
    func setupImageView() {
        addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            profilePicture.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
            profilePicture.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profilePicture.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
            ])
        
    }
    
    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -45)
            ])
    }

    func setupTaskLabel() {
        addSubview(taskLabel)
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            taskLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -25)
            ])
    }
}
