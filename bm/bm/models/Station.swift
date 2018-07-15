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
    
    let name: String
    let type: String
    let location: CLLocation
    
    init(name: String, type: String, latitude: Double, longitude: Double) {
        self.name = name
        self.type = type
        self.location = CLLocation(latitude: latitude, longitude: longitude)
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
