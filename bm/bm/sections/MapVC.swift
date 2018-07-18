//
//  MapVC.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    // MARK: - API
    func set(navigationTitle: String) {
        self.navigationTitle = navigationTitle
    }
    
    func set(stations: [Station]) {
        self.stations = stations
    }
    
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    // Vars
    private var stations: [Station] = []
    private var navigationTitle: String?
    private var activeVehicles = 0
    // Calculated
    private var createBtn: UIBarButtonItem {
        return navigationItem.rightBarButtonItem!
    }
    // Constants
    private let maxVehiclesAllowed = 10
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        set(mapView: self.mapView, referenceStation: stations.first!)
    }
    
    // MARK: - Helper
    private func setNavBar() {
        navigationItem.title = navigationTitle
        setNabBarBtn()
    }
    
    private func setNabBarBtn() {
        let createBarBtn = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createAction))
        createBarBtn.isEnabled = false
        navigationItem.rightBarButtonItem = createBarBtn
    }
    
    // MARK: - Actions
    @objc func createAction(sender: UIBarButtonItem) {
        createRoute { (isRouteCreated) in
            guard isRouteCreated else { return }
            
            // TODO: Increment
            activeVehicles += 1
            print(activeVehicles)
            
            // TODO: start travel
            // .....
        }
    }
    
    func createRoute(completion: (Bool) -> ()) {
        guard isMaxVehicleNumberReached(currentNumberOfVehicles: activeVehicles, maxAllowed: maxVehiclesAllowed) else {
            print("Max number reached.....")
            completion(false)
            return
        }
        
        // TODO: create route
        // ........ polyline
        completion(true)
    }
    
    // MARK: - Helper
    private func set(mapView: MKMapView, referenceStation: Station) {
        mapView.delegate = self
        mapView.addAnnotations(stations)
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        
        let regionRadius: CLLocationDistance = 12000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(referenceStation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        return Station.getStationMarkerAnnotation(mapView: mapView, andAnnotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        createBtn.isEnabled = true
        
        if view is MKMarkerAnnotationView {
            let mTintView = view as! MKMarkerAnnotationView
            mTintView.markerTintColor = UIColor.selectedStation
        }
        
        logSelectedAnnotation(mapView: self.mapView, view: view, stations: self.stations)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view is MKMarkerAnnotationView {
            let mTintView = view as! MKMarkerAnnotationView
            mTintView.markerTintColor = UIColor.nonSelectedStation
        }
        
        createBtn.isEnabled = false
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
