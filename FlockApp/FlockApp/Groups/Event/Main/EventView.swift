//
//  EventView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import GoogleMaps

protocol EventViewDelegate: AnyObject {
    func segmentedDetailsPressed()
    func segmentedPeoplePressed()
    func cancelPressed()
}

class EventView: UIView {
    
    weak var delegate: EventViewDelegate?
    
    public lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed))
        return button
    }()
    @objc func cancelButtonPressed() {
        delegate?.cancelPressed()
    }
    
    lazy var eventAddress: UILabel = {
       let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
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
        label.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
        label.text = "MY EVENT HERE"
        label.textAlignment = .center
        return label
    }()
    
    lazy var detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        segmentedControl.tintColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(EventView.indexChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var myMapView: GMSMapView = {
        var view = GMSMapView()
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.793840, longitude: -73.886012, zoom: 11)
        view = GMSMapView.init(frame: CGRect.zero, camera: camera)
        //        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
//                myMapView = GMSMapView.init(frame: CGRect.zero, camera: camera)
        //        view = myMapView
        //        view.mapType = MKMapType.standard
        //        view.isZoomEnabled = true
        //        view.isScrollEnabled = true
        //        view.center = self.center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        addEventTitle()
        addSegmentedControl()
        addDetailView()
        addEventAddress()
        addEventDate()
        addEventTracking()
        addTableView()
        addMapView()
//
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect(x: 60, y: 500, width: 250, height: 250), camera: camera)
//        addSubview(mapView)
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
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
        eventAddress.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.30),
        eventAddress.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.80)
            ])
    }
    
    private func addEventDate() {
        addSubview(eventDate)
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        eventDate.topAnchor.constraint(equalTo: eventAddress.topAnchor, constant: 50),
        eventDate.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
        eventDate.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.30),
        eventDate.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.80)
            ])
    }
    
    private func addEventTracking() {
        addSubview(eventTracking)
        eventTracking.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventTracking.topAnchor.constraint(equalTo: eventDate.topAnchor, constant: 30),
            eventTracking.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            eventTracking.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.30),
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
        detailView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.40),
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
    
    private func addMapView() {
        addSubview(myMapView)
        myMapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myMapView.topAnchor.constraint(equalTo: eventTracking.bottomAnchor, constant: 20),
            myMapView.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            myMapView.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.8),
            myMapView.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.8)
            ])
        
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("Details")
            detailView.isHidden = false
            eventTracking.isHidden = false
            eventAddress.isHidden = false
            eventDate.isHidden = false
            detailView.isUserInteractionEnabled = true
            peopleTableView.isHidden = true
            peopleTableView.isUserInteractionEnabled = false
        case 1:
            print("People")
            detailView.isHidden = true
            eventTracking.isHidden = true
            eventAddress.isHidden = true
            eventDate.isHidden = true
            detailView.isUserInteractionEnabled = false
            peopleTableView.isHidden = false
            peopleTableView.isUserInteractionEnabled = true
            myMapView.isHidden = true
        default:
            break
        }
    }


}
