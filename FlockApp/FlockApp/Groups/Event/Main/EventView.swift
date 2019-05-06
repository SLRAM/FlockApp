//  EventView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import GoogleMaps

protocol EventViewDelegate: AnyObject {
    func cancelPressed()
    func getDirections()
}

class EventView: UIView {
    
    weak var delegate: EventViewDelegate?

    public lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed))
        return button
    }()
    
    public lazy var directionsButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(image: UIImage(named: "icons8-car-512"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(getDirections))
        let button = UIBarButtonItem(title: "Directions", style: UIBarButtonItem.Style.plain, target: self, action: #selector(getDirections))
        return button
    }()

    @objc func cancelButtonPressed() {
        delegate?.cancelPressed()
    }
    
    @objc func getDirections() {
        delegate?.getDirections()
    }
    
    lazy var mapButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        return button
    }()

    
    lazy var eventAddress: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.text = "47-10 Austell Pl. 11111"
        return label
    }()

    lazy var eventDate: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.text = "June 8, 2019, 5:00 PM - 10:00 PM"
        return label
    }()

    lazy var eventTracking: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.text = "June 8, 2019, 5:00 PM - 10:00 PM"
        return label
    }()

    lazy var myMapView: GMSMapView = {
        var view = GMSMapView()

        let camera = GMSCameraPosition.camera(withLatitude: 40.793840, longitude: -73.886012, zoom: 11)
        view = GMSMapView.init(frame: CGRect.zero, camera: camera)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        addMapView()
        addEventTracking()
        addEventDate()
        addEventAddress()
        addMapButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addEventAddress() {
        addSubview(eventAddress)
        eventAddress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventAddress.bottomAnchor.constraint(equalTo: eventDate.topAnchor, constant: -30),
            eventAddress.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventAddress.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5)
            ])
    }
    
    private func addEventDate() {
        addSubview(eventDate)
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventDate.bottomAnchor.constraint(equalTo: eventTracking.topAnchor, constant: -30),
            eventDate.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
            ])
    }

    private func addEventTracking() {
        addSubview(eventTracking)
        eventTracking.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventTracking.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            eventTracking.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
            ])
//        eventTracking.isHidden = true
    }

    private func addMapView() {
        addSubview(myMapView)
        myMapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myMapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            myMapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            myMapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            myMapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
            ])
        
    }
    
    private func addMapButton() {
        addSubview(mapButton)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapButton.topAnchor.constraint(equalTo: myMapView.topAnchor),
            mapButton.bottomAnchor.constraint(equalTo: myMapView.bottomAnchor),
            mapButton.leadingAnchor.constraint(equalTo: myMapView.leadingAnchor),
            mapButton.trailingAnchor.constraint(equalTo: myMapView.trailingAnchor)
            ])
    }
}




//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        //this kicks off whenever authorization is turned on or off
//        print("user changed the authorization")
//
//        //        let currentLocation = mapView.userLocation
//        //        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//        //
//        //        myMapView.setRegion(myCurrentRegion, animated: true)
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //this kicks off whenever the user's location has noticeably changed
//        print("user has changed locations")
//        guard let currentLocation = locations.last else {return}
//        print("The user is in lat: \(currentLocation.coordinate.latitude) and long:\(currentLocation.coordinate.longitude)")
//
//        //        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//        //
//        //        myMapView.setRegion(myCurrentRegion, animated: true)
//    }
//
