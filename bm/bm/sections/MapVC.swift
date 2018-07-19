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
    var vehicles = [Vehicle]() {
        didSet {
            print(vehicles.count)
            if vehicles.count == 0 {
                print("gotovo.....")
            }
        }
    }
    
    var tappedLocation: MKAnnotation? // TODO: remove
    
    private var stations: [Station] = []
    private var navigationTitle: String?
    private var activeVehicles: Int {
        return vehicles.count
    }
    private var vehicleRefreshTimer: Timer?
    private var statisticsRefreshTimer: Timer?
    private var selectedStation: Station? {
        didSet {
            print("=========selectedStation OBJECT===========")
            print("id: \(self.selectedStation!.id)")
            print("title: \(self.selectedStation!.title ?? "")")
        }
    }
    private var randomStation: Station? {
        didSet {
            print("=========randomStation OBJECT===========")
            print("id: \(String(describing: self.randomStation?.id))")
            print("title: \(self.randomStation?.title ?? "")")
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
        setInformationFeedbackRefreshTimers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        invalidateTimers()
    }
    
    // MARK: - Helper
    private func invalidateTimers() {
        vehicleRefreshTimer?.invalidate()
        statisticsRefreshTimer?.invalidate()
    }
    
    private func setInformationFeedbackRefreshTimers() {
        vehicleRefreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshVehiclInfo), userInfo: nil, repeats: true)
//        statisticsRefreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refreshStatsInfo), userInfo: nil, repeats: true)
    }
    
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
    @objc func refreshVehiclInfo(sender: Timer) {
        for v in vehicles {
            print("\(v.name) - remaining stations \(v.route.count)")
            print("========")
            
            if v.route.count == 0 {
                print("gotovo")
                if let index = vehicles.index(of: v) {
                    vehicles.remove(at: index)
                    mapView.remove(v.polyline)
                    mapView.removeAnnotation(v)

                }
            } else {
                

                mapView.removeAnnotation(v)
                v.route.remove(at: 0)
                if let currentLocation2D = v.route.first {
                    let currentLocation = CLLocation(latitude: currentLocation2D.latitude, longitude: currentLocation2D.longitude)
                    v.location = currentLocation
                }
                mapView.addAnnotation(v)
                
            }
        }
    }
    
    @objc func refreshStatsInfo(sender: Timer) {
        print("refreshStatsInfo")
    }
    
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
//        let locationPoint = sender.location(in: mapView)
//        let pickedCoordinate = mapView.convert(locationPoint, toCoordinateFrom: mapView)
//
//        let img = UIImage(named: "busPin")
//        let vehicle = Vehicle(id: "xxxxx", name: "bus", image: UIImage(named: "busPin")!, latitude: pickedCoordinate.latitude, longitude: pickedCoordinate.longitude)
//
////        let vehicle = Vehicle(id: "123", name: "busplus", type: "bus", latitude: pickedCoordinate.latitude, longitude: pickedCoordinate.longitude)
//
//        if self.tappedLocation != nil {
//            mapView.removeAnnotation(self.tappedLocation!)
//        }
//
//        self.tappedLocation = vehicle
//        mapView.addAnnotation(vehicle)
    }
    
    @objc func createAction(sender: UIBarButtonItem) {
        createRoute { (isRouteCreated) in
            guard isRouteCreated else { return }
            // TODO: start travel
            // .....
        }
    }

    // Helper Temp
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
        
        getRouteAndCoordinatesFor(sourceLocation: sourceLocation, destinationLocation: destinationLocation, locationManager: self.locationManager) { (route, coordinates) in
            self.mapView.add(route.polyline)
            let shortCoordinates = coordinates.extractArrayElements(withStep: coordinates.count / 20)
            print(shortCoordinates.count)
            print(coordinates.count)
            print("============")
            
            let vh = Vehicle(id: "00  \(self.vehicles.count + 1)", name: "Bus No: \(self.vehicles.count + 1)", image: UIImage(named: "busPin")!, latitude: sourceLocation.coordinate.latitude, longitude: sourceLocation.coordinate.longitude, route: shortCoordinates  as! [CLLocationCoordinate2D], polyline: route.polyline)
            self.vehicles.append(vh)
        }
        completion(true)
    }
    
    
    func getRouteAndCoordinatesFor(sourceLocation: CLLocation, destinationLocation: CLLocation, locationManager: CLLocationManager, success: @escaping (MKRoute, [CLLocationCoordinate2D]) -> Void) {
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
                    success(route, route.polyline.coordinates)
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
            return Vehicle.getBUSMarkerAnnotation(mapView: mapView, andAnnotation: annotation)
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
            guard randIndex <= visibleStations.count else { return nil}
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
