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
    private var stations = [Station]()
    private var navigationTitle: String?
    private var activeVehicles: Int {
        return stationEngine.vehicles.count
    }
    private var vehicleRefreshTimer: Timer?
    private var statisticsRefreshTimer: Timer?
    
    var sourceLocation: CLLocation {
        return CLLocation(latitude: stationEngine.selectedStation!.coordinate.latitude, longitude: stationEngine.selectedStation!.coordinate.longitude)
    }
    
    var destinationLocation: CLLocation {
        return CLLocation(latitude: stationEngine.randomStation!.coordinate.latitude, longitude: stationEngine.randomStation!.coordinate.longitude)
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
    let stationEngine = StationEngine()
    private let locationManager = CLLocationManager()
    private let maxVehiclesAllowed = 10
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        MapEngine.set(mapView: mapView, delegate: self, annotations: stations)
        stationEngine.set(stations: self.stations)
        setRefreshTimers()
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
    
    private func setRefreshTimers() {
        vehicleRefreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshVehicleInfo), userInfo: nil, repeats: true)
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
    @objc func refreshVehicleInfo(sender: Timer) {
        stationEngine.refreshVehicleStatus { (isDestinationReached, vehicle) in
            guard isDestinationReached == false else {
                self.mapEngine.removeVehicleAndRoute(mapView: self.mapView, vehicle: vehicle)
                return
            }
            self.mapEngine.updateMapForVehicle(mapView: self.mapView, vehicle: vehicle)
        }
    }
    
    @objc func refreshStatsInfo(sender: Timer) {
        print("refreshStatsInfo")
    }
    
    @objc func createTravelAction(sender: UIBarButtonItem) {
        guard isMaxVehicleNumberReached else {
            AlertHelper.presentAlert(title: "Warning", message: "Max Number Of Vehicles Reached", onViewController: self)
            return
        }
        setRandomStation()
        mapEngine.getRoute(source: sourceLocation, destination: destinationLocation, locationManager: locationManager, completion: { (route, coordinates) in
            self.mapEngine.createRoute(mapView:  self.mapView, route: route, coordinates: coordinates, completion: { (vehicle) in
                self.stationEngine.vehicles.append(vehicle)
            })
        }, fail: { (isFail) in
            print("lgetRoute fail")
        })
    }
    
    func setRandomStation() {
        stationEngine.randomStation = getRandomStation(fromStations: stationEngine.stations, excludingStation: stationEngine.selectedStation!)
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
