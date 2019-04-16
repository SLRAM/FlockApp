//
//  EventViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import Firebase
import FirebaseFirestore

class EventViewController: UIViewController {
    
    private var friends = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.eventView.peopleTableView.reloadData()
            }
        }
    }
    private var invited: [String]  = [String]() {
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
        fetchInvites()
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
    
    // 1. invites = ["userId", "userId"]
    // 2. event has a collection
    func fetchInvites() {
        guard let event = event else {
            print("event is nil")
            return
        }
        DBService.firestoreDB
            .collection(EventsCollectionKeys.CollectionKey)
            .document(event.documentId)
            .collection(InvitedCollectionKeys.CollectionKey)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("failed to fetch invites: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    print("found \(snapshot.documents.count) invites")
                     self.invited = snapshot.documents.map {
                        let dictionary = $0.data() as? [String: String]
                        guard let value = dictionary?.values.first else {return ""}
                        return value
                        
                    }
                }

        }
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
//        if event != nil {
//            for i in event!.invited {
//                DBService.fetchUser(userId: i) { (error, user) in
//                    if let error = error {
//                        print(error)
//                    } else if let user = user {
//                        self.friends.append(user)
//                    }
//                }
//            }
//        }
    }
}

extension EventViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return friends.count
        return invited.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = eventView.peopleTableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        let friend = invited[indexPath.row]
        cell.textLabel?.text = friend
//        cell.textLabel?.text = friends[indexPath.row].displayName
        return cell
    }
}
