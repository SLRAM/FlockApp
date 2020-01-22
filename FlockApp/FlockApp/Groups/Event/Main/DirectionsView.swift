//
//  DirectionsView.swift
//  FlockApp
//
//  Created by Nathalie  on 4/25/19.
//

import UIKit
import MapKit

class DirectionsView: UIView {
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func  commonInit() {
        setupMapContrains()
    }
    
    private func setupMapContrains() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        mapView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
        mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        mapView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
