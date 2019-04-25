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

//    lazy var myMapView: MKMapView = {
//        var view = MKMapView()
//
//        let camera = MKMapCamera(lookingAtCenter: <#T##CLLocationCoordinate2D#>, fromDistance: <#T##CLLocationDistance#>, pitch: <#T##CGFloat#>, heading: <#T##CLLocationDirection#>)
//
//        let camera = GMSCameraPosition.camera(withLatitude: 40.793840, longitude: -73.886012, zoom: 11)
//        view = GMSMapView.init(frame: CGRect.zero, camera: camera)
//        //        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
//        //        myMapView = GMSMapView.init(frame: CGRect.zero, camera: camera)
//        //        view = myMapView
//        //        view.mapType = MKMapType.standard
//        //        view.isZoomEnabled = true
//        //        view.isScrollEnabled = true
//        //        view.center = self.center
//        return view
//    }()

}

//guard let venueLat = self.venue?.location.lat,
//    let venueLong = self.venue?.location.lng else {return}
//let coordinate = CLLocationCoordinate2DMake(venueLat,venueLong)
//let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
//mapItem.name = self.venue?.name
//mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])



