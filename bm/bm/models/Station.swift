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
