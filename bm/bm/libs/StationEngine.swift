//
//  StationEngine.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/22/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct VehicleStatistics {
    var currentNumberOfVehicles: Int
    var totalNumberOfVehiclesCreated: Int
    var totalTimeInSeconds: Int
}

class StationEngine {
    
    var vehStats = VehicleStatistics(currentNumberOfVehicles: 0, totalNumberOfVehiclesCreated: 0, totalTimeInSeconds: 0)
    
    func updateStats() {
        vehStats.currentNumberOfVehicles = vehicles.count
    }
    
    // MARK: - API
    func set(stations: [Station]) {
        self.stations = stations
    }
    
    func refreshVehicleStatus(completion: @escaping (Bool, Vehicle) -> Void) {
        for vehicle in vehicles {
            handle(vehicle: vehicle) { (isVehicleAtDestination) in
                completion(isVehicleAtDestination, vehicle)
            }
            vehStats.totalTimeInSeconds += 1
        }
    }

    func handle(vehicle: Vehicle, isVehicleAtDestination: (Bool) -> Void) {
        if vehicle.route.count == 0 {
            if let index = vehicles.index(of: vehicle) {
                vehicles.remove(at: index)
                isVehicleAtDestination(true)
            }
        } else {
            isVehicleAtDestination(false)
        }
        
        updateStats()
    }
    
    var vehicles = [Vehicle]()

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
            print("id: \(String(describing: self.randomStation?.id))")
            print("title: \(self.randomStation?.title ?? "")")
        }
    }
    
    func setRandomStation() {
        self.randomStation = self.getRandomStation(fromStations: self.stations, excludingStation: self.selectedStation!)
    }
    
    // MARK: - Properties
    var currentNumberOfVehicles: Int {
        return vehicles.count
    }
    var totalNumberOfVehiclesCreated = 0
    var totalTimeInSeconds = 0
    
    
    
    private var stations = [Station]()
    
    
    // MARK: - Helper
    private func getRandomStation(fromStations stations: [Station], excludingStation: Station) -> Station? {
        if let indexOfSelectedStation = stations.index(of: excludingStation) {
            let randomStationInt = getRandomInteger(maximum: stations.count, notAllowedInt: indexOfSelectedStation)
            return stations[randomStationInt]
        }
        return nil
    }
}
