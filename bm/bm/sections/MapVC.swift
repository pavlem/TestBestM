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
        self.navigationTitle = navigationTitle
    }
    
    func set(stations: [Station]) {
        self.stations = stations
    }
    
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    // Vars
    private var stations: [Station] = []
    private var navigationTitle: String?
    private var activeVehicles = 0
    // Calculated
    private var createBtn: UIBarButtonItem {
        return navigationItem.rightBarButtonItem!
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        set(mapView: self.mapView)
    }
    
    // MARK: - Helper
    private func setNavBar() {
        navigationItem.title = navigationTitle
        setNabBarBtn()
    }
    
    private func setNabBarBtn() {
        let createBarBtn = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createAction))
        createBarBtn.isEnabled = false
        navigationItem.rightBarButtonItem = createBarBtn
    }
    
    // MARK: - Actions
    @objc func createAction(sender: UIBarButtonItem) {
//        guard activeVehicles <= 10 else {
//            print("Max number reached.....")
//            return
//        }
//
//        if activeVehicles < 10 {
//            activeVehicles += 1
//            print("Create.....\(activeVehicles)")
//        }
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
    
    func getSelectedIndex(forMarkerAnnotationView annotationView: MKMarkerAnnotationView) -> Int? { //TODO: Unit Test
        let visible = mapView.visibleAnnotations()
        for (ind, v) in visible.enumerated() {
            let viewSelected = mapView.view(for: v) as! MKMarkerAnnotationView
            if annotationView == viewSelected {
                return ind
            }
        }
        return nil
    }
    
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
}

// MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identationViewIdent = "stationID"
        let glyphText = "B.M."
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
    
    func loadJsonFrom(fileNamed fileName: String) -> NSDictionary {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath!))
        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
        return jsonResult
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        createBtn.isEnabled = true
        
        if view is MKMarkerAnnotationView {
            let mTintView = view as! MKMarkerAnnotationView
            mTintView.markerTintColor = .red
        }
        
        if let selectedIndex = getSelectedIndex(forMarkerAnnotationView: view as! MKMarkerAnnotationView) {
            print("selected station...\(selectedIndex)")
            let randInt = getRandomInteger(maximum: 5, notAllowedInt: selectedIndex)
            print("random station...\(randInt)")
            let visibleStations = mapView.visibleAnnotations()
            print(visibleStations[selectedIndex].title! ?? "none")
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view is MKMarkerAnnotationView {
            let mTintView = view as! MKMarkerAnnotationView
            mTintView.markerTintColor = .green
        }
        
        createBtn.isEnabled = false
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
