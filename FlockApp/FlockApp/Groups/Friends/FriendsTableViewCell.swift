//
//  FriendsTableViewCell.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    public lazy var profilePicture: CircularImageView = {
        let image = CircularImageView()
        return image
    }()
    
    public lazy var nameLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    public lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    lazy var acceptFriend: UIButton = {
        let button = UIButton()
        button.setTitle("Accept", for: .normal)
        button.backgroundColor = .green
        button.isHidden = true
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()
    lazy var declineFriend: UIButton = {
        let button = UIButton()
        button.setTitle("Decline", for: .normal)
        button.backgroundColor = .red
        button.isHidden = true
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()
    lazy var cancelRequest: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .red
        button.isHidden = true
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupButtons()
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
    func setupButtons() {
        addSubview(acceptFriend)
        addSubview(declineFriend)
        addSubview(cancelRequest)
        acceptFriend.translatesAutoresizingMaskIntoConstraints = false
        declineFriend.translatesAutoresizingMaskIntoConstraints = false
        cancelRequest.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            declineFriend.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            declineFriend.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            declineFriend.heightAnchor.constraint(equalToConstant: 25),
            declineFriend.widthAnchor.constraint(equalToConstant: 80),
            acceptFriend.trailingAnchor.constraint(equalTo: declineFriend.leadingAnchor, constant: -10),
            acceptFriend.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            acceptFriend.heightAnchor.constraint(equalToConstant: 25),
            acceptFriend.widthAnchor.constraint(equalToConstant: 80),
            cancelRequest.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            cancelRequest.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cancelRequest.heightAnchor.constraint(equalToConstant: 25),
            cancelRequest.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
}
