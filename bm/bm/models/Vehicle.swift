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
    let location: CLLocation
    
    init(id: String, name: String, image: UIImage, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.image = image
        self.location = CLLocation(latitude: latitude, longitude: longitude)
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
