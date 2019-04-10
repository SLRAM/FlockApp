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
    
    lazy var myTableView: UITableView = {
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
    
//    let items = ["Details" , "People"]
//    let segmentedControl = UISegmentedControl(items : items)
//    segmentedControl.center = self.view.center
//    segmentedControl.selectedSegmentIndex = 0
//    segmentedControl.addTarget(self, action: #selector(EventViewController.indexChanged(_:)), for: .valueChanged)
//
//    segmentedControl.layer.cornerRadius = 5.0
//    segmentedControl.backgroundColor = .red
//    segmentedControl.tintColor = .yellow

    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        addSubview(segmentedControl)
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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
