//
//  MapView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import MapKit
import GoogleMaps

class MapView: UIView {

    lazy var myMapView: GMSMapView = {
        var view = GMSMapView()
        let camera = GMSCameraPosition.camera(withLatitude: 40.793840, longitude: -73.886012, zoom: 11)
        view = GMSMapView.init(frame: CGRect.zero, camera: camera)
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
extension MapView {
    func setupViews() {
        backgroundColor = #colorLiteral(red: 0.5872428417, green: 0.1077810898, blue: 0.7153506875, alpha: 1)
        setupHomeMapView()
    }
    
    func setupHomeMapView() {
        addSubview(myMapView)
        myMapView.translatesAutoresizingMaskIntoConstraints = false
        myMapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        myMapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        myMapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        myMapView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
    }
}
