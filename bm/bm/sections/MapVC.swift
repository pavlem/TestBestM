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
        
        
//        let fff = loadJsonFrom(fileNamed: "stationMOCList")
        
        
        if let path = Bundle.main.path(forResource: "stationMOCList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let stationData = jsonResult["stationData"] as? [Any] {
                    let stations = parseDict(stationData: stationData)
                    print("==========")
                    // do stuff
                }
            } catch {
                // handle error
                print("====")
            }
        }
        
        
        
        set(mapView: self.mapView)
    }
    
    func parseDict(stationData: [Any]) -> [Station] {
        
        var stations = [Station]()
        
        for st in stationData {
            let stationObj = Station(json: st as! [String : Any])
            stations.append(stationObj)
        }
        
        return stations
        
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
    
//    stationsMOC.txt
    
    
    
    
    func loadJsonFrom(fileNamed fileName: String) -> NSDictionary {
        
        let filePath = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath!))
        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
        return jsonResult
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
