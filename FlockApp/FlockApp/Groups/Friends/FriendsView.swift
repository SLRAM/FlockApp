//
//  FriendsView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

class FriendsView: UIView {
    
    lazy var friendSearch: UISearchBar = {
        let tf = UISearchBar()
        tf.placeholder = "Search Friends"
        tf.barTintColor = #colorLiteral(red: 0.9868895411, green: 0.7339923382, blue: 0.9123610854, alpha: 1)
        return tf
    }()
    lazy var myTableView: UITableView = {
        let tv = UITableView()
        tv.register(FriendsTableViewCell.self, forCellReuseIdentifier: "FriendsTableViewCell")
        tv.rowHeight = (UIScreen.main.bounds.width)/4
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        backgroundColor = .clear
        setupFriendSearch()
        setupTableView()
    }
    
    func setupFriendSearch() {
        addSubview(friendSearch)
        friendSearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendSearch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            friendSearch.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            friendSearch.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
            ])
    }
    
    func setupTableView() {
        addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            myTableView.topAnchor.constraint(equalTo: friendSearch.bottomAnchor),
            myTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}
