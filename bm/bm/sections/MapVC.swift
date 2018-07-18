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
    var tappedLocation: MKAnnotation? // TODO: remove
    private var stations: [Station] = []
    private var navigationTitle: String?
    private var activeVehicles = 0
    var selectedStation: Station? {
        didSet {
            print("=========selectedStation OBJECT===========")
            print("id: \(self.selectedStation!.id)")
            print("title: \(self.selectedStation!.title ?? "")")
        }
    }
    var randomStation: Station? {
        didSet {
            print("=========randomStation OBJECT===========")
            print("id: \(self.randomStation!.id)")
            print("title: \(self.randomStation!.title ?? "")")
        }
    }
    
    // Calculated
    private var createBtn: UIBarButtonItem {
        return navigationItem.rightBarButtonItem!
    }
    private var isCreationOfAnotherVehicleOK: Bool {
        return isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: activeVehicles, maxAllowed: maxVehiclesAllowed)
    }
    // Constants
    private let locationManager = CLLocationManager()
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
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        let locationPoint = sender.location(in: mapView)
        let pickedCoordinate = mapView.convert(locationPoint, toCoordinateFrom: mapView)
        let vehicle = Vehicle(id: "123", name: "busplus", type: "bus", latitude: pickedCoordinate.latitude, longitude: pickedCoordinate.longitude)
        
        if self.tappedLocation != nil {
            mapView.removeAnnotation(self.tappedLocation!)
        }

        self.tappedLocation = vehicle
        mapView.addAnnotation(vehicle)
    }
    
    @objc func createAction(sender: UIBarButtonItem) {
        createRoute { (isRouteCreated) in
            guard isRouteCreated else { return }
            
            // TODO: Increment active vehicles
            activeVehicles += 1
            print(activeVehicles)
            
            // TODO: start travel
            // .....
        }
    }

    func createRoute(completion: (Bool) -> ()) {
        // Check if ok
        guard isCreationOfAnotherVehicleOK else {
            print("Max number reached.....")
            completion(false)
            return
        }

        self.randomStation = getRandomStationExcludingSelected(forMapView: mapView, view:  mapView.view(for: mapView.selectedAnnotations.first!)!)
        let sourceLocation = CLLocation(latitude: selectedStation!.coordinate.latitude, longitude: selectedStation!.coordinate.longitude)
        let destinationLocation = CLLocation(latitude: randomStation!.coordinate.latitude, longitude: randomStation!.coordinate.longitude)
        
        setRouteFor(mapView: self.mapView, locationManager: self.locationManager, sourceLocation: sourceLocation, andDestination: destinationLocation)
        
        completion(true)
    }
    
    // MARK: - Helper
    private func setRouteFor(mapView: MKMapView, locationManager: CLLocationManager, sourceLocation: CLLocation, andDestination destinationLocation: CLLocation) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation.coordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate, addressDictionary: nil)
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let region = MKCoordinateRegionMakeWithDistance(sourceLocation.coordinate, 15000, 15000)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                for route in (response?.routes)! {
                    print(route.distance)
                    print("coord.......")
                    print(route.polyline.coordinates.count)
                    mapView.add(route.polyline)
                }
            }
        }
    }
    
    private func set(mapView: MKMapView, referenceStation: Station) {
        mapView.delegate = self
        mapView.addAnnotations(stations)
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        
        let regionRadius: CLLocationDistance = 15000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(referenceStation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor().getRandomColor()
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation is Vehicle {
            return Station.getBUSMarkerAnnotation(mapView: mapView, andAnnotation: annotation)
        } else if annotation is Station {
            return Station.getStationMarkerAnnotation(mapView: mapView, andAnnotation: annotation)
        } else {
            return Station.getStationMarkerAnnotation(mapView: mapView, andAnnotation: annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        createBtn.isEnabled = true
        
        if let selectedStation = view.annotation as? Station {
            self.selectedStation = selectedStation
            if view is MKMarkerAnnotationView {
                let mTintView = view as! MKMarkerAnnotationView
                mTintView.markerTintColor = UIColor.selectedStation
            }
            
            self.randomStation = getRandomStationExcludingSelected(forMapView: self.mapView, view: view)
        }
        
//        logSelectedAnnotation(mapView: self.mapView, view: view, stations: self.stations)
    }
    
    func getRandomStationExcludingSelected(forMapView mapView: MKMapView, view: MKAnnotationView) -> Station? {
        
        if let selectedIndex = getSelectedIndex(forMarkerAnnotationView: view as! MKMarkerAnnotationView, mapView: mapView) {
            let randIndex = getRandomInteger(maximum: stations.count, notAllowedInt: selectedIndex)
            let visibleStations = mapView.visibleAnnotations()
//            let randomAnnotation = visibleStations[randIndex]
            let randomStationView = visibleStations[randIndex]
            if let randomStation = randomStationView as? Station {
                return randomStation
            }
        }

        return nil
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


public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
