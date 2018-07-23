//
//  MainVC.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var getStationsBtn: UIButton!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getStationsBtn.isEnabled = true
    }
    
    // MARK: - Actions
    @IBAction func getStations(_ sender: UIButton) {
        self.getStationsBtn.isEnabled = false
        
        fetchStations { (stationsRealm) in
            DispatchQueue.main.async {
                self.persistStations(stationsRealm: stationsRealm)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.showMapVC()
            }
        }
    }
    
    // MARK: - Helper
    private func persistStations(stationsRealm: [StationRealm]) {
        DbHelper.shared.persist(stations: stationsRealm)
    }
    
    private func showMapVC() {
        let stationsRealm = DbHelper.shared.fetchAllStationsFromDB()
        let stations = self.getStationObjectsFrom(stationsRealm: stationsRealm)
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.mapVC) as! MapVC
        mapVC.set(navigationTitle: "Map List")
        mapVC.set(stations: stations)
        self.show(mapVC, sender: nil)
    }
    
    private func getStationObjectsFrom(stationsRealm: [StationRealm]) -> [Station] {
        var stations = [Station]()
        for stRealm in stationsRealm {
            let st = Station(stationRealm: stRealm)
            stations.append(st)
        }
        return stations
    }
    
    // MARK: - Parsing to Station objects - if needed
//    private func parseDict(stationData: [Any]) -> [Station] {
//        var stations = [Station]()
//        for st in stationData {
//            let stationObj = Station(json: st as! [String : Any])
//            stations.append(stationObj)
//        }
//        return stations
//    }
    
    // MARK: - Parsing to Station Realm objects
    private func parseDictionaryToRealmObject(stationData: [Any]) -> [StationRealm] {
        var stations = [StationRealm]()
        for st in stationData {
            let stRealm = StationRealm()
            stRealm.set(json: st as! [String : Any])
            stations.append(stRealm)
        }
        return stations
    }
    
    private func fetchStations(completion: @escaping ([StationRealm]) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            
            //            sleep(1)
            var stationsRealm = [StationRealm]()

            if let path = Bundle.main.path(forResource: "stationMOCList", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let stationDictionaryData = jsonResult["stationData"] as? [Any] {
                        stationsRealm = self.parseDictionaryToRealmObject(stationData: stationDictionaryData)
                        completion(stationsRealm)
                    }
                } catch {
                    print("Error")
                }
            }
        }
    }
}
