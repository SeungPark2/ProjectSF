//
//  MapViewController.swift
//  ProjectSF
//
//  Created by PST on 2019/12/23.
//  Copyright © 2019 PST. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

var soccerfield = [Soccer]()

class MapViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var searchBar: UIBarButtonItem?
    let userLocation = CLLocation(latitude: 37.490770, longitude: 126.900519)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setMapView()
    }
    
    
    @IBAction func mainBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchName(_ sender: UIButton) {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        present(search, animated: true)
    }
    
    func fetchData() {
        guard let fileName = Bundle.main.path(forResource: "SoccerInfo", ofType: "json") else {return}
        let filePath = URL(fileURLWithPath: fileName)
        var data: Data?
        
        do {
            data = try Data(contentsOf: filePath, options: Data.ReadingOptions(rawValue: 0))
        } catch let error {
            data = nil
            print(error.localizedDescription)
        }
        
        if let jsonData = data {
            let json = try? JSON(data: jsonData)
            if let SoccerJSONs = json?["DATA"].array {
                
                for SoccerJSON in SoccerJSONs {
                    if let soccer = Soccer.from(json: SoccerJSON) {
                        soccerfield.append(soccer)
                    }
                }
            }
            
        }
    }
    
    func setMapView() {
        mapView?.delegate = self
        mapView?.addAnnotations(soccerfield)
        zoomMapOn(location: userLocation)
    }
    
    func zoomMapOn(location: CLLocation) {
        let coordinateRegin = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500 * 2.0, longitudinalMeters: 500 * 2.0)
        mapView?.setRegion(coordinateRegin, animated: true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.becomeFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequset = MKLocalSearch.Request()
        guard let searchtext = searchBar.text else { return}
        searchRequset.naturalLanguageQuery = searchtext
        
        let activeSearch = MKLocalSearch(request: searchRequset)
        
        activeSearch.start { (response, error) in
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("Error")
            }
            else {
                guard let latitude = response?.boundingRegion.center.latitude else {return}
                guard let longitude = response?.boundingRegion.center.longitude else {return}
                
                let annotation = MKPointAnnotation()
                annotation.title = searchtext
                self.mapView?.addAnnotation(annotation)
                
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.020, longitudeDelta: 0.020)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView?.setRegion(region, animated: true)
            }
            
        }
    }
    
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView?.showsUserLocation = true
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Soccer {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let playlist = self.storyboard?.instantiateViewController(identifier: "PlayListView") else {return}
        self.navigationController?.pushViewController(playlist, animated: true)
        
        guard let titleName = view.annotation?.title else {return}
        
        if view.annotation?.title == titleName {
            self.navigationController?.topViewController?.title = titleName
        }
    }
    
}
