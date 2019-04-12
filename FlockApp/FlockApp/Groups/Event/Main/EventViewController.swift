//
//  EventViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

class EventViewController: UIViewController {
    
    private var friends = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.eventView.peopleTableView.reloadData()
            }
        }
    }
    
    let eventView = EventView()
    
    public var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(event?.invited)
            navigationItem.leftBarButtonItem = eventView.cancelButton
        
        self.view.addSubview(eventView)
        guard let unwrappedEvent = event else {return}
        let eventTitle = unwrappedEvent.eventName
        let eventAddress = unwrappedEvent.locationString
        let eventTracking = unwrappedEvent.startDate
        eventView.eventTitle.text = eventTitle
        eventView.eventAddress.text = eventAddress
        eventView.delegate = self
        eventView.peopleTableView.dataSource = self
        eventView.peopleTableView.delegate = self
        eventView.peopleTableView.register(EventPeopleTableViewCell.self, forCellReuseIdentifier: "peopleCell")
        eventView.peopleTableView.isHidden = true
        eventView.peopleTableView.isUserInteractionEnabled = false
    }

}

extension EventViewController: EventViewDelegate {
    func segmentedDetailsPressed() {
        
    }
    
    func segmentedPeoplePressed() {
        
    }
    
    func cancelPressed() {
        dismiss(animated: true)
    }
}

extension EventViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (event?.invited.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = eventView.peopleTableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        cell.textLabel?.text = event?.invited[indexPath.row]
        return cell
    }


}
