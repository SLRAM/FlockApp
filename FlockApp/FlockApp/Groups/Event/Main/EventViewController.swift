//
//  EventViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

class EventViewController: UIViewController {
    
    
    let eventView = EventView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(eventView)
        eventView.peopleTableView.dataSource = self
        eventView.peopleTableView.delegate = self
        eventView.peopleTableView.register(EventPeopleTableViewCell.self, forCellReuseIdentifier: "peopleCell")
        eventView.peopleTableView.isHidden = true
        eventView.peopleTableView.isUserInteractionEnabled = false
    }

}

extension EventViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = eventView.peopleTableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        return cell
    }


}
