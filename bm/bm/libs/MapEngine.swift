//
//  MapHelper.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/22/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapEngine {
    
    static let shared = MapEngine()
    
    class func set(mapView: MKMapView, delegate: UIViewController, regionRadius: CLLocationDistance? = 15000, annotations: [MKAnnotation]) {
        mapView.delegate = delegate as? MKMapViewDelegate
        mapView.addAnnotations(annotations)
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        let regionRadius: CLLocationDistance = regionRadius!
        if let referenceStation = annotations.first {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(referenceStation.coordinate, regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func getRoute(source: CLLocation, destination: CLLocation, locationManager: CLLocationManager, completion: @escaping (MKRoute, [CLLocationCoordinate2D]) -> Void, fail: @escaping (Bool) -> Void) {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let sourcePlacemark = MKPlacemark(coordinate: source.coordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil)
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard error == nil else {
                fail(true)
                return
            }
            guard let route = response?.routes.first else {
                fail(true)
                return
            }
            completion(route, route.polyline.coordinates)
        }
    }
    
    func createRoute(mapView: MKMapView, route: MKRoute, coordinates: [CLLocationCoordinate2D], completion: @escaping (Vehicle) -> Void) {
        mapView.add(route.polyline)
        let shortCoordinates = coordinates.extractArrayElements(withStep: coordinates.count / 20)
        let sourceLocation = coordinates.first!
        let vh = Vehicle(id: getVehicleId(), name: getVehicleName(), image: UIImage(named: "busPin")!, latitude: sourceLocation.latitude, longitude: sourceLocation.longitude, route: shortCoordinates  as! [CLLocationCoordinate2D], polyline: route.polyline)
        vehicleId += 1
        completion(vh)
    }
    
    func removeVehicleAndRoute(mapView: MKMapView, vehicle: Vehicle) {
        mapView.remove(vehicle.polyline)
        mapView.removeAnnotation(vehicle)
    }
    
    func updateMapForVehicle(mapView: MKMapView, vehicle: Vehicle) {
        mapView.removeAnnotation(vehicle)
        vehicle.route.remove(at: 0)
        if let currentLocation2D = vehicle.route.first {
            let currentLocation = CLLocation(latitude: currentLocation2D.latitude, longitude: currentLocation2D.longitude)
            vehicle.location = currentLocation
        }
        mapView.addAnnotation(vehicle)
    }
    // MARK: - Helper
    private var vehicleId = 0

    private func getVehicleId() -> String {
        return String(vehicleId)
    }
    
    private func getVehicleName() -> String {
        return "Bus no: " + String(vehicleId)
    }
}
