//
//  Station.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Station: NSObject {
    
    let name: String
    let type: String
    let location: CLLocation
    
    init(name: String, type: String, lat: Double, long: Double) {
        self.name = name
        self.type = type
        self.location = CLLocation(latitude: lat, longitude: long)
    }
}

extension Station: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return type
    }
}
