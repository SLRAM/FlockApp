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
        self.backgroundColor = .white
        addEventTitle()
        addSegmentedControl()
        addDetailView()
        addTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addEventTitle() {
        addSubview(eventTitle)
        eventTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        eventTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
        eventTitle.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.10),
        eventTitle.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.90),
        eventTitle.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addSegmentedControl() {
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
        segmentedControl.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 40),
        segmentedControl.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.08),
        segmentedControl.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.90)
        ])
    }
    
    private func addDetailView() {
        addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        detailView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
        detailView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
        detailView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.60),
        detailView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.90)
        ])
    }
    
    private func addTableView() {
        addSubview(peopleTableView)
        peopleTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            peopleTableView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            peopleTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            peopleTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.60),
            peopleTableView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.90)
            ])
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("Details")
            detailView.isHidden = false
            detailView.isUserInteractionEnabled = true
            peopleTableView.isHidden = true
            peopleTableView.isUserInteractionEnabled = false
        case 1:
            print("People")
            detailView.isHidden = true
            detailView.isUserInteractionEnabled = false
            peopleTableView.isHidden = false
            peopleTableView.isUserInteractionEnabled = true
        default:
            break
        }
    }


}
