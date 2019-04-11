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
    
    //address, date, tracking
    
    lazy var eventAddress: UILabel = {
       let label = UILabel()
        label.text = "47-10 Austell Pl. 11111"
        return label
    }()
    
    lazy var eventDate: UILabel = {
        let label = UILabel()
        label.text = "June 8, 2019, 5:00 PM - 10:00 PM"
        return label
    }()
    
    lazy var eventTracking: UILabel = {
        let label = UILabel()
        label.text = "June 8, 2019, 5:00 PM - 10:00 PM"
        return label
    }()
    
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
    
    private func addEventAddress() {
        addSubview(eventAddress)
        eventAddress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        eventAddress.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 10),
        eventAddress.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
        eventAddress.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.70),
        eventAddress.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.80)
            ])
    }
    
    private func makeEventDate() {
        addSubview(eventDate)
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        eventDate.topAnchor.constraint(equalTo: eventAddress.topAnchor, constant: 10),
        eventDate.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
        eventDate.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.70),
        eventDate.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.80)
            ])
    }
    
    private func makeEventTracking() {
        addSubview(eventTracking)
        eventTracking.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventTracking.topAnchor.constraint(equalTo: eventDate.topAnchor, constant: 10),
            eventTracking.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            eventTracking.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.70),
            eventTracking.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.80)
            ])
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
        segmentedControl.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07),
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
