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
    }
    


}

extension EventViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

//height for view around 75%
