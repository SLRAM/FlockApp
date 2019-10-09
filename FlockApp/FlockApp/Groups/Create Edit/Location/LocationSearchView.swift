//
//  LocationSearchView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import MapKit
import GoogleMaps

protocol LocationSearchViewDelegate: AnyObject {
    func userLocationButton()
}

class LocationSearchView: UIView {
    weak var delegate: LocationSearchViewDelegate?
    lazy var mySearchBarView: UIView = {
        let myv = UIView()
        myv.backgroundColor = #colorLiteral(red: 0.2660466433, green: 0.2644712925, blue: 0.2672616839, alpha: 1)
        return myv
    }()
    lazy var locationSearch: UISearchBar = {
        let tf = UISearchBar()
        tf.placeholder = "Search Locations"
        tf.barTintColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)

        return tf
    }()
    
    lazy var myTableView: UITableView = {
        let tv = UITableView()
        tv.register(LocationSearchTableViewCell.self, forCellReuseIdentifier: "LocationSearchTableViewCell")
        tv.rowHeight = (UIScreen.main.bounds.width)/4
        tv.backgroundColor = .clear
        return tv
    }()
    
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
extension LocationSearchView {
    func setupViews() {
        backgroundColor = .white
        setupSearchBarView()
        setupHomeListView()
        setupHomeMapView()
    }
    func setupSearchBarView() {
        addSubview(mySearchBarView)
        mySearchBarView.translatesAutoresizingMaskIntoConstraints = false
        mySearchBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mySearchBarView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mySearchBarView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        mySearchBarView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
        setupQueryTextField()
    }
    func setupQueryTextField() {
        mySearchBarView.addSubview(locationSearch)
        locationSearch.translatesAutoresizingMaskIntoConstraints = false
        locationSearch.topAnchor.constraint(equalTo: mySearchBarView.topAnchor).isActive = true
        locationSearch.bottomAnchor.constraint(equalTo: mySearchBarView.bottomAnchor).isActive = true
        locationSearch.leadingAnchor.constraint(equalTo: mySearchBarView.leadingAnchor).isActive = true
        locationSearch.trailingAnchor.constraint(equalTo: mySearchBarView.trailingAnchor).isActive = true
    }
    
    func setupHomeListView() {
        addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        myTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.93).isActive = true
    }
    func setupHomeMapView() {
        addSubview(myMapView)
        myMapView.translatesAutoresizingMaskIntoConstraints = false
        myMapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        myMapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        myMapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        myMapView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.93).isActive = true
    }
}
