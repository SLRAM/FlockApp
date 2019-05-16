//
//  MapView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import MapKit
import GoogleMaps

class EventPeopleView: UIView {
    
    
    lazy var myMapView: GMSMapView = {
        var view = GMSMapView()
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.793840, longitude: -73.886012, zoom: 11)
        view = GMSMapView.init(frame: CGRect.zero, camera: camera)
        //        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
        //        myMapView = GMSMapView.init(frame: CGRect.zero, camera: camera)
        //        view = myMapView
        //        view.mapType = MKMapType.standard
        //        view.isZoomEnabled = true
        //        view.isScrollEnabled = true
        //        view.center = self.center
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        setupViews()
    }
    
}

extension EventPeopleView {
    func setupViews() {
        backgroundColor = .white
        
        //        let gradient = CAGradientLayer()
        //        gradient.frame    = self.bounds
        //        gradient.colors = [UIColor.magenta.cgColor,UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.blue.cgColor]
        //        self.layer.addSublayer(gradient)
        setupHomeMapView()
    }
    
    func setupHomeMapView() {
        //        mapView = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: 200, height: 200), camera: GMSCameraPosition.camera(withLatitude: 51.050657, longitude: 10.649514, zoom: 5.5))
        //
        //        //so the mapView is of width 200, height 200 and its center is same as center of the self.view
        //        mapView?.center = self.view.center
        //
        //        self.view.addSubview(mapView!)
        addSubview(myMapView)
        myMapView.translatesAutoresizingMaskIntoConstraints = false
        myMapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        myMapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        myMapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        myMapView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
    }
}
