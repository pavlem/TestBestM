//
//  MapVC.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    // MARK: - API
    func set(navigationTitle: String) {
        navigationItem.title = navigationTitle
    }
    
    func set(stations: [Station]) {
        self.stations = stations
    }
    
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    private var stations: [Station] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set(mapView: self.mapView)
    }
    
    // MARK: - Helper
    private func set(mapView: MKMapView) {
        mapView.delegate = self
        mapView.addAnnotations(stations)
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        
        let regionRadius: CLLocationDistance = 12000
        let hq = stations.first
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(hq!.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identationViewIdent = "stationID"
        let glyphText = "BestM"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identationViewIdent) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identationViewIdent)
            annotationView?.glyphText = glyphText
        } else {
            annotationView?.annotation = annotation
            annotationView?.glyphText = glyphText
        }
        annotationView?.markerTintColor = .green
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let allVisible = mapView.annotations
//        for ann in allVisible {
//            let view = mapView.view(for: ann)
//            (view as! MKMarkerAnnotationView).markerTintColor = .green
//        }
        
        if view is MKMarkerAnnotationView {
            let mTintView = view as! MKMarkerAnnotationView
            mTintView.markerTintColor = .red
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view is MKMarkerAnnotationView {
            let mTintView = view as! MKMarkerAnnotationView
            mTintView.markerTintColor = .green
        }
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
