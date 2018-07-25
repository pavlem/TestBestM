//
//  MapVC+Extension.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/22/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import MapKit

// MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor().getRandomColor()
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation is Vehicle {
            return Vehicle.getBUSMarkerAnnotation(mapView: mapView, andAnnotation: annotation)
        } else if annotation is Station {
            return Station.getStationMarkerAnnotation(mapView: mapView, andAnnotation: annotation)
        } else {
            return Station.getStationMarkerAnnotation(mapView: mapView, andAnnotation: annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let selectedStation = view.annotation as? Station {
            createBtn.isEnabled = true
            stationEngine.selectedStation = selectedStation
            if view is MKMarkerAnnotationView {
                let mTintView = view as! MKMarkerAnnotationView
                mTintView.markerTintColor = UIColor.selectedStation
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view is MKMarkerAnnotationView {
            let mTintView = view as! MKMarkerAnnotationView
            mTintView.markerTintColor = UIColor.nonSelectedStation
        }
        
        createBtn.isEnabled = false
    }
}
