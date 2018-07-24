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

struct Statistics {
    var title: String
    var currentNumberOfVehicles: Int
    var totalNumberOfVehiclesCreated: Int
    var totalTimeInSeconds: Int
}

class StationEngine {
    
    // MARK: - API
    func set(stations: [Station]) {
        self.stations = stations
    }
    
    func updateStats() {
        vehicleStats.currentNumberOfVehicles = vehicles.count
    }
    
    func refreshVehicleStatus(completion: @escaping (Bool, Vehicle) -> Void) {
        for vehicle in vehicles {
            handle(vehicle: vehicle) { (isVehicleAtDestination) in
                completion(isVehicleAtDestination, vehicle)
            }
            vehicleStats.totalTimeInSeconds += 1
        }
    }

    func handle(vehicle: Vehicle, isVehicleAtDestination: (Bool) -> Void) {
        if vehicle.route.count == 0 {
            if let index = self.vehicles.index(of: vehicle) {
                self.vehicles.remove(at: index)
                isVehicleAtDestination(true)
            }
        } else {
            isVehicleAtDestination(false)
        }
        
        updateStats()
    }
    
    var vehicleStats = Statistics(title: "Stats", currentNumberOfVehicles: 0, totalNumberOfVehiclesCreated: 0, totalTimeInSeconds: 0)
    var vehicles = [Vehicle]()

    var selectedStation: Station?
    var randomStation: Station?
    
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
    func isMaxAllowedVehicleNumberReached(maxAllowed: Int) -> Bool {
        if self.currentNumberOfVehicles == maxAllowed {
            return true
        }
        return false
    }

    func getRandomStation(fromStations stations: [Station], excludingStation: Station) -> Station? {
        if let indexOfSelectedStation = stations.index(of: excludingStation) {
            let randomStationInt = getRandomInteger(maximum: stations.count, notAllowedInt: indexOfSelectedStation)
            return stations[randomStationInt]
        }
        return nil
    }
}
