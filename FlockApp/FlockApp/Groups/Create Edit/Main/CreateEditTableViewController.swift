//
//  CreateEditTableViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 9/2/19.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMaps
import Kingfisher


class CreateEditTableViewController: UITableViewController {

    
    let cellId = "EventCell"
    
    
    let eventView = CreateEditTableView()
    
    public var event: Event?
    public var tag: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = eventView.cancelButton
        self.title = event?.eventName
        let frameHeight = view.frame.height
        let frameSection = view.frame.height/3
        self.tableView.sectionHeaderHeight = frameHeight - frameSection
        self.tableView.register(EventPeopleTableViewCell.self, forCellReuseIdentifier: "personCell")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1).withAlphaComponent(0.2)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func setTableViewBackgroundGradient(sender: UITableViewController, _ topColor:UIColor, _ bottomColor:UIColor) {
        
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = sender.tableView.bounds
        let backgroundView = UIView(frame: sender.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        sender.tableView.backgroundView = backgroundView
    }
    
    
    
    
    
    

        
        
    

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return eventView
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
//        let person = invited[indexPath.row]
//        cell.profilePicture.kf.setImage(with: URL(string: person.photoURL ?? "no photo"), placeholder: #imageLiteral(resourceName: "ProfileImage.png"))
//        cell.nameLabel.text = person.displayName
//        cell.taskLabel.text = person.task
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        cell.layer.cornerRadius = 50
        
        return cell
    }
    
}

extension CreateEditTableViewController: CreateEditTableViewDelegate {
    func cancelPressed() {
        
    }
    
    func createPressed() {
        
    }
    
    func addressPressed() {
        
    }
    
    func datePressed() {
        
    }
    
    func friendsPressed() {
        
    }
    
    func imagePressed() {
        
    }
    
    func trackingIncreasePressed() {
        
    }
    
    func trackingDecreasePressed() {
        
    }
    

}
