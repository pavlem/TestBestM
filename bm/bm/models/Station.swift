//
//  Station.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Station: NSObject {
    let id: String
    let name: String
    let type: String
    let location: CLLocation
    
    init(json: [String: Any]) {
        id = json["stationId"] as? String ?? "-1"
        name = json["name"] as? String ?? ""
        type = json["type"] as? String ?? ""
        let latitude = json["latitude"] as? Double ?? 0.0
        let longitude = json["longitude"] as? Double ?? 0.0
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(stationRealm: StationRealm) {
        self.id = stationRealm.id
        self.name = stationRealm.name
        self.type = stationRealm.type
        self.location = CLLocation(latitude: stationRealm.latitude, longitude: stationRealm.longitude)
    }
    
    init(id: String, name: String, type: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension Station {
    static func getStationMarkerAnnotation(mapView: MKMapView, andAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identationViewIdent = "stationID"
        let glyphText = "Best_M"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identationViewIdent) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identationViewIdent)
            annotationView?.glyphText = glyphText
        } else {
            annotationView?.annotation = annotation
            annotationView?.glyphText = glyphText
        }
        annotationView?.markerTintColor = UIColor.nonSelectedStation
        return annotationView
    }
}

extension Station: MKAnnotation {
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
    var subtitle: String? {
        get {
            return type
        }
    }
}
