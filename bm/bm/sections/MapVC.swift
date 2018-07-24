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
    @IBOutlet var statsView: StatisticView!
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
    
    // TODO: Refactor this to look better 
    private var isMaxVehicleNumberReached: Bool {    
        return stationEngine.isMaxAllowedVehicleNumberReached(maxAllowed: maxVehiclesAllowed) ? true : false
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
        setStatsView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        invalidateTimers()
    }
    
    // MARK: - Helper
    private func setStatsView() {
        statsView.statistics = stationEngine.vehicleStats
        statsView.frame = CGRect(x: 0, y: 0, width: (view.frame.width * 4) / 5, height: 200)
        statsView.isHidden = true
        statsView.alpha = 0.6
        view.addSubview(statsView)
    }
    
    private func invalidateTimers() {
        vehicleRefreshTimer?.invalidate()
        statisticsRefreshTimer?.invalidate()
    }
    
    private func setRefreshTimers() {
        vehicleRefreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshVehicleInfo), userInfo: nil, repeats: true)
        statisticsRefreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refreshStatsInfo), userInfo: nil, repeats: true)
    }
    
    private func setNavBar() {
        navigationItem.title = navigationTitle
        setNabBarBtns()
    }
    
    private func setNabBarBtns() {
        let showHideStats = UIBarButtonItem(title: "stats".localized, style: .plain, target: self, action: #selector(showHideStatsAction))
        let createBarBtn = UIBarButtonItem(title: "create".localized, style: .plain, target: self, action: #selector(createTravelAction))
        createBarBtn.isEnabled = false
        navigationItem.rightBarButtonItems = [createBarBtn, showHideStats]
    }
    
    // MARK: - Actions
    @objc func refreshVehicleInfo(sender: Timer) {
        stationEngine.refreshVehicleStatus { (isDestinationReached, vehicle) in
            guard isDestinationReached == false else {
                self.mapEngine.removeVehicleAndRoute(mapView: self.mapView, vehicle: vehicle)
                self.stationEngine.updateStats()
                self.statsView.statistics = self.stationEngine.vehicleStats
                return
            }
            self.mapEngine.updateMapForVehicle(mapView: self.mapView, vehicle: vehicle)
        }
    }
    
    @objc func refreshStatsInfo(sender: Timer) {
        DispatchQueue.main.async {
            self.statsView.statistics = self.stationEngine.vehicleStats
        }
    }
    
    @objc func showHideStatsAction(sender: UIBarButtonItem) {
        statsView.isHidden = !statsView.isHidden
    }
    
    @objc func createTravelAction(sender: UIBarButtonItem) {
        
        guard isMaxVehicleNumberReached == false else {
            AlertHelper.presentAlert(title: "waring".localized, message: "maxVehicleNoReached".localized, onViewController: self)
            self.createBtn.isEnabled = true
            return
        }
        
        self.createBtn.isEnabled = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        stationEngine.setRandomStation()
        mapEngine.getRoute(source: sourceLocation, destination: destinationLocation, locationManager: locationManager, completion: { (route, coordinates) in
            
            self.mapEngine.createRoute(mapView:  self.mapView, route: route, coordinates: coordinates, completion: { (vehicle) in

                self.stationEngine.vehicles.append(vehicle)
                self.stationEngine.vehicleStats.totalNumberOfVehiclesCreated += 1
                self.stationEngine.updateStats()
                self.statsView.statistics = self.stationEngine.vehicleStats

                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.createBtn.isEnabled = true
                }
            })
        }, fail: { (isFail) in
            print("getRoute fail")
        })
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
