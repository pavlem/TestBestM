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
    var vehicles = [Vehicle]() { didSet { if vehicles.count == 0 { print("gotovo.....") } } } //TODO:rem didS...
    var tappedLocation: MKAnnotation? // TODO: remove
    
    var stations: [Station] = []
    private var navigationTitle: String?
    private var activeVehicles: Int {
        return vehicles.count
    }
    private var vehicleRefreshTimer: Timer?
    private var statisticsRefreshTimer: Timer?
    var selectedStation: Station? {
        didSet {
//            print("=========selectedStation OBJECT===========")
//            print("id: \(self.selectedStation!.id)")
//            print("title: \(self.selectedStation!.title ?? "")")
        }
    }
    var randomStation: Station? {
        didSet {
//            print("=========randomStation OBJECT===========")
//            print("id: \(String(describing: self.randomStation?.id))")
//            print("title: \(self.randomStation?.title ?? "")")
        }
    }
    
    // Calculated
    var createBtn: UIBarButtonItem {
        return navigationItem.rightBarButtonItem!
    }
    private var isMaxVehicleNumberReached: Bool {
        return isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: activeVehicles, maxAllowed: maxVehiclesAllowed)
    }
    // Constants
    private let mapEngine = MapEngine()
    private let locationManager = CLLocationManager()
    private let maxVehiclesAllowed = 10
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        MapEngine.set(mapView: mapView, delegate: self, stations: stations)
        setTimers()
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
    
    private func setTimers() {
        vehicleRefreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshVehiclInfo), userInfo: nil, repeats: true)
//        statisticsRefreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refreshStatsInfo), userInfo: nil, repeats: true)
    }
    
    private func setNavBar() {
        navigationItem.title = navigationTitle
        setNabBarBtn()
    }
    
    private func setNabBarBtn() {
        let createBarBtn = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createTravelAction))
        createBarBtn.isEnabled = false
        navigationItem.rightBarButtonItem = createBarBtn
    }
    
    // MARK: - Actions
    @objc func refreshVehiclInfo(sender: Timer) {
        for v in vehicles {
            handle(vehicle: v)
        }
    }
    
    @objc func refreshStatsInfo(sender: Timer) {
        print("refreshStatsInfo")
    }
    
    @objc func createTravelAction(sender: UIBarButtonItem) {
        guard isMaxVehicleNumberReached else {
            AlertHelper.presentAlert(title: "warning", message: "Max Number Reached", onViewController: self)
            return
        }
    
        let locations = getSourceAndDestinationLocation()
        guard locations.source != nil, locations.destination != nil else {
            return
        }
        
        mapEngine.getRoute(source: locations.source!, destination: locations.destination!, locationManager: locationManager, completion: { (route, coordinates) in
            
            self.mapEngine.createRoute(mapView:  self.mapView, route: route, coordinates: coordinates, completion: { (vehicle) in
                self.vehicles.append(vehicle)
            })
        }, fail: { (isFail) in
            print("lgetRoute fail")
        })
    }
    
    func getSourceAndDestinationLocation() -> (source: CLLocation?, destination: CLLocation?) {
        self.randomStation = getRandomStationExcludingSelected(forMapView: mapView, view: mapView.view(for: mapView.selectedAnnotations.first!)!)
        let sourceLocation = CLLocation(latitude: selectedStation!.coordinate.latitude, longitude: selectedStation!.coordinate.longitude)
        guard self.randomStation != nil else {
            return (nil, nil)
        }
        
        let destinationLocation = CLLocation(latitude: randomStation!.coordinate.latitude, longitude: randomStation!.coordinate.longitude)
        
        return (sourceLocation, destinationLocation)
    }
    
    func handle(vehicle: Vehicle) {
        if vehicle.route.count == 0 {
            if let index = vehicles.index(of: vehicle) {
                mapEngine.removeVehicleAndRoute(mapView: self.mapView, vehicle: vehicle)
                vehicles.remove(at: index)
            }
        } else {
            mapEngine.updateMapForVehicle(mapView: self.mapView, vehicle: vehicle)
        }
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
