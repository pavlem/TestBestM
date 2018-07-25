//
//  Vehicle.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/19/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class Vehicle: NSObject {
    let id: String
    let name: String
    let image: UIImage
    var location: CLLocation
    let polyline: MKPolyline
    var route: [CLLocationCoordinate2D]
    let distance: Double
    
    init(id: String, name: String, image: UIImage, latitude: Double, longitude: Double, route: [CLLocationCoordinate2D], polyline: MKPolyline, distance: Double) {
        self.id = id
        self.name = name
        self.image = image
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.route = route
        self.polyline = polyline
        self.distance = distance
    }
}

extension Vehicle: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    var title: String? {
        get {
            return name
        }
    }
}

extension Vehicle {
    static func getBUSMarkerAnnotation(mapView: MKMapView, andAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identationViewIdent = "busID"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identationViewIdent)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identationViewIdent)
            if let vehicle = annotation as? Vehicle {
                annotationView?.image = vehicle.image
            }
        } else {
            if let vehicle = annotation as? Vehicle {
                annotationView?.image = vehicle.image
            }
        }
        return annotationView
    }
}
