//
//  EventViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import Firebase

class EventViewController: UIViewController {
    
    private var friends = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.eventView.peopleTableView.reloadData()
            }
        }
    }
    
    let eventView = EventView()
    private var listener: ListenerRegistration!
    
    public var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = eventView.cancelButton
        getInvitees()
        self.view.addSubview(eventView)
        guard let unwrappedEvent = event else {return}
        let eventTitle = unwrappedEvent.eventName
        
        let eventAddress = unwrappedEvent.locationString
        let eventTracking = unwrappedEvent.startDate
        let date = unwrappedEvent.startDate
        let formatter = ISO8601DateFormatter()
//        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate, .withTime]
        let str = formatter.string(from: date)
        
        
       
        let formattedDate = str.formatISODateString(dateFormat: "EEEE, MMM d, yyyy, h:mm a")
        eventView.eventDate.text = formattedDate
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
    
    private func getInvitees() {
        if event != nil {
            for i in event!.invited {
                DBService.fetchUser(userId: i) { (error, user) in
                    if let error = error {
                        print(error)
                    } else if let user = user {
                        self.friends.append(user)
                    }
                }
            }
        }
    }
}

extension EventViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = eventView.peopleTableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        cell.textLabel?.text = friends[indexPath.row].displayName
        return cell
    }


}
