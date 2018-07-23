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

class StationEngine {

    var stations = [Station]()
    
    func set(stations: [Station]) {
        self.stations = stations
    }
    
    func refreshVehicleStatus(completion: @escaping (Bool, Vehicle) -> Void) {
        for vehicle in vehicles {
            handle(vehicle: vehicle) { (isVehicleAtDestination) in
                completion(isVehicleAtDestination, vehicle)
            }
        }
    }

    
    func handle(vehicle: Vehicle, isVehicleAtDestination: (Bool) -> Void) {
        if vehicle.route.count == 0 {
            if let index = vehicles.index(of: vehicle) {
//                mapEngine.removeVehicleAndRoute(mapView: self.mapView, vehicle: vehicle)
                vehicles.remove(at: index)
                isVehicleAtDestination(true)
            }
        } else {
            isVehicleAtDestination(false)
//            mapEngine.updateMapForVehicle(mapView: self.mapView, vehicle: vehicle)
        }
    }
    
    var vehicles = [Vehicle]()

    
}
