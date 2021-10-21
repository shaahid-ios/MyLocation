//
//  ViewController.swift
//  MyMapLocation
//
//  Created by Shaahid on 20/10/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchResultsUpdating {
    
  
    let mapView = MKMapView()

    let searchVC  = UISearchController(searchResultsController: ResultsViewController())
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        view.addSubview(mapView)
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,!query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultsViewController else{
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                print("found result")
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            
            }
            
        }
        
    }

}
extension ViewController: ResultsViewControllerDelegate{
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        
        searchVC.dismiss(animated: true, completion: nil)
        
        //remove all map pins
        
        let annotations = mapView.annotations
        
        mapView.removeAnnotations(annotations)
        
        
       let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta:0.2)), animated: true
        )
        
        
    }
    
}
