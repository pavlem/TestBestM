//
//  HelperFunctions.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/18/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import MapKit

func logSelectedAnnotation(mapView: MKMapView, view: MKAnnotationView, stations: [Station]) {
//    print("=========Selected OBJECT===========")
//    if let selectedStation = view.annotation as? Station {
//        print("id: \(selectedStation.id)")
//        print("title: \(selectedStation.title ?? "")")
//    }
//    print("=========Selected OBJECT===========")
    if let selectedIndex = getSelectedIndex(forMarkerAnnotationView: view as! MKMarkerAnnotationView, mapView: mapView) {
        print("================")
        print("selected station index...\(selectedIndex)")
        let randIndex = getRandomInteger(maximum: stations.count, notAllowedInt: selectedIndex)
        print("random station index...\(randIndex)")
        let visibleStations = mapView.visibleAnnotations()
        let randomAnnotation = visibleStations[randIndex]
        print("randomAnnotation title...\(randomAnnotation.title! ?? "")")
        print("=========Random OBJECT===========")
        let randomStationView = visibleStations[randIndex]
        if let randomStation = randomStationView as? Station {
            print("rand station obj title: \(randomStation.title ?? "")")
            print("rand station obj id: \(randomStation.id)")
        }
        print("=========Random OBJECT===========")
    }
}

// Utility
func getRandomInteger(maximum: Int, notAllowedInt: Int) -> Int { //TODO: Unit Test
    let randomInt = random(maximum)
    guard randomInt != notAllowedInt else {
        return getRandomInteger(maximum: maximum, notAllowedInt: notAllowedInt)
    }
    return randomInt
}

func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

func getSelectedIndex(forMarkerAnnotationView annotationView: MKMarkerAnnotationView, mapView: MKMapView) -> Int? { //TODO: Unit Test
    let visible = mapView.visibleAnnotations()
    for (ind, v) in visible.enumerated() {
        if let viewSelected = mapView.view(for: v) as? MKMarkerAnnotationView {
            if annotationView == viewSelected {
                return ind
            }
        }
    }
    return nil
}

func isMaxAllowedVehicleNumberReached(currentNumberOfVehicles: Int, maxAllowed: Int) -> Bool {
    guard currentNumberOfVehicles < maxAllowed else {
        return false
    }
    return true
}
