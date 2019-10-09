//
//  LocationSearchViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

protocol LocationSearchViewControllerDelegate: AnyObject {
    func getLocation(locationTuple: (String, CLLocationCoordinate2D))
}
class LocationSearchViewController: UIViewController {
    
    weak var delegate: LocationSearchViewControllerDelegate?
    private let locationSearchView = LocationSearchView()
    public let identifer = "marker"
    var allMarkers = [GMSMarker]()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var locationCoordinate: CLLocationCoordinate2D?
    var query : String?
    var near = String()
    var locationString = String()
    var locationTuple = (str:"", location:CLLocationCoordinate2D.init())
    var statusRawValue = Int32()
    var userLocation : CLLocationCoordinate2D?
    var updatedUserLocation = CLLocationCoordinate2D()
    class MyAnnotation: MKPointAnnotation {
        var tag: Int!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Location"

        mapListButton()
        locationSearchView.delegate = self
        homeViewSetup()
        searchCompleter.delegate = self
        designSetup()
        locationSearchView.locationSearch.delegate = self
    }
    func designSetup() {
        locationSearchView.myTableView.tableFooterView = UIView()
        let backgroundImage = UIImage(named: "blueGreen")
        let imageView = UIImageView(image: backgroundImage)
        locationSearchView.myTableView.backgroundView = imageView
//        locationSearchView.backgroundColor = #colorLiteral(red: 0.8442592025, green: 0.4776551127, blue: 0.9347509146, alpha: 1).withAlphaComponent(0.9)
        locationSearchView.backgroundColor = #colorLiteral(red: 0.5872428417, green: 0.1077810898, blue: 0.7153506875, alpha: 1)

    }
    
    func mapListButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .plain, target: self, action: #selector(addButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func addButton() {
        guard let noLocation = locationSearchView.locationSearch.text?.isEmpty else {return}
        let inactiveMarker = allMarkers.isEmpty
        if noLocation || inactiveMarker {
            let alertController = UIAlertController(title: "Please provide a location to add to your event.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else {
            delegate?.getLocation(locationTuple: locationTuple)
            print("saved")
            let alertController = UIAlertController(title: "This location has been added to your event.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.navigationController?.popViewController(animated: true)

            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
    func homeViewSetup() {
        view.addSubview(locationSearchView)
        locationSearchView.myTableView.delegate = self
        locationSearchView.myTableView.dataSource = self
        locationSearchView.locationSearch.delegate = self
    }
}
extension LocationSearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do code here to make sure coordinates are obtained from location. possible alert saying sorry the location you entered could not be found try again.
        tableView.deselectRow(at: indexPath, animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = true
        locationSearchView.locationSearch.resignFirstResponder()
        let completion = searchResults[indexPath.row]
        let completionFull = "\(completion.title) \(completion.subtitle)"
        locationSearchView.locationSearch.text = completionFull
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            self.locationCoordinate = response?.mapItems[0].placemark.coordinate
            print("Ending coordinate: \(String(describing: self.locationCoordinate))")
            DispatchQueue.main.async {
                guard let inputLocation = self.locationCoordinate else {return}
                self.locationTuple = (completionFull, inputLocation)
                
                self.locationSearchView.myMapView.animate(toLocation: CLLocationCoordinate2D(latitude: inputLocation.latitude, longitude: inputLocation.longitude))
                let locate = GMSCameraPosition.camera(withLatitude: inputLocation.latitude,
                                                      longitude: inputLocation.longitude,
                                                      zoom: 17)
                for marker in self.allMarkers {
                    marker.map = nil
                }
                self.allMarkers.removeAll()
                let locationMarker = GMSMarker.init()
                locationMarker.position = inputLocation
                locationMarker.title = "Event Location"
                locationMarker.map = self.locationSearchView.myMapView
                self.allMarkers.append(locationMarker)
            }
            
            
        }
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.locationSearchView.myMapView.alpha = 1.0
        })
        self.view.addSubview(locationSearchView)
        locationSearchView.reloadInputViews()
    }
}

extension LocationSearchViewController: GMSMapViewDelegate {
}
extension LocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                self.locationSearchView.myMapView.alpha = 0.0
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                self.locationSearchView.myMapView.alpha = 1.0
            })
            self.view.addSubview(locationSearchView)
            locationSearchView.reloadInputViews()
        }
        searchCompleter.queryFragment = searchText
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension LocationSearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        locationSearchView.myTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    }
}

extension LocationSearchViewController: LocationSearchViewDelegate {
    func userLocationButton() {
    }
}
