//
//  InvitedView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/10/19.
//

import UIKit

class InvitedView: UIView {

    lazy var friendSearch: UISearchBar = {
        let tf = UISearchBar()
        tf.placeholder = "Search Friends"
        tf.barTintColor = #colorLiteral(red: 0.5249566436, green: 0.8283091784, blue: 0.7542427182, alpha: 1)
        //        tf.layer.cornerRadius = 10
        //        tf.layer.borderWidth = 2
        //        tf.layer.borderColor = UIColor.gray.cgColor
        //        tf.backgroundColor = #colorLiteral(red: 0.6924440265, green: 0.6956507564, blue: 0.7034814358, alpha: 1)
        return tf
    }()
    
    lazy var myTableView: UITableView = {
        let tv = UITableView()
        tv.register(InvitedTableViewCell.self, forCellReuseIdentifier: "InvitedTableViewCell")
        tv.rowHeight = (UIScreen.main.bounds.width)/4
        tv.backgroundColor = .clear
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        setupViews()
    }

}
extension InvitedView {
    func setupViews() {
        backgroundColor = .white
        
        //        let gradient = CAGradientLayer()
        //        gradient.frame = self.bounds
        //        gradient.colors = [UIColor.magenta.cgColor,UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.blue.cgColor]
        //        self.layer.addSublayer(gradient)
        setupFriendSearch()
        setupTableView()
    }

    func setupFriendSearch() {
        addSubview(friendSearch)
        friendSearch.translatesAutoresizingMaskIntoConstraints = false
        friendSearch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
//        friendSearch.bottomAnchor.constraint(equalTo: mySearchBarView.bottomAnchor).isActive = true
        friendSearch.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        friendSearch.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func setupTableView() {
        addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        myTableView.topAnchor.constraint(equalTo: friendSearch.bottomAnchor).isActive = true

        myTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
//        myTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.95).isActive = true
    }
}
