//
//  EventView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

protocol EventViewDelegate: AnyObject {
    func segmentedDetailsPressed()
    func segmentedPeoplePressed()
}

class EventView: UIView {
    
    weak var delegate: EventViewDelegate?
    
    lazy var eventTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.text = "MY EVENT HERE"
        label.textAlignment = .center
        return label
    }()
    
    lazy var detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        return view
    }()
    
    lazy var peopleTableView: UITableView = {
        let tv = UITableView()
        tv.register(EventDetailCell.self, forCellReuseIdentifier: "EventDetailCell")
        tv.rowHeight = (UIScreen.main.bounds.width)/4
        tv.backgroundColor = .clear
        return tv
    }()

    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Details", "People"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(EventView.indexChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        addSubview(segmentedControl)
        addSubview(peopleTableView)
        addSubview(eventTitle)
        addSubview(detailView)
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        eventTitle.translatesAutoresizingMaskIntoConstraints = false
        eventTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        eventTitle.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.10).isActive = true
        eventTitle.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.90).isActive = true
        eventTitle.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 40).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.08).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.90).isActive = true
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        detailView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true
        detailView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.60).isActive = true
        detailView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.90).isActive = true
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("Details");
        case 1:
            print("People")
        default:
            break
        }
    }


}

//make a new view that's just used for dimensions (no need to make a new file)
//add people view, add detail view - in that order
