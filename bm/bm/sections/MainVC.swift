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
        
        fetchStations { (stations, stationsR) in
            let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.mapVC) as! MapVC
            mapVC.set(navigationTitle: "Map List")
            mapVC.set(stations: stations)
        
            for s in stationsR {
                if let station = realm.object(ofType: StationRealm.self, forPrimaryKey: s.id) {
                    DbHelper.shared.update(object: station)
                } else {
                    DbHelper.shared.add(object: s)
                }
            }
            
            self.show(mapVC, sender: nil)
        }
    }
    
    // MARK: - Helper
    // TODO: - Move to parser file
    private func parseDict(stationData: [Any]) -> [Station] {
        var stations = [Station]()
        for st in stationData {
            let stationObj = Station(json: st as! [String : Any])
            stations.append(stationObj)
        }
        return stations
    }
    
    private func parseDictRealm(stationData: [Any]) -> [StationRealm] {

        var stations = [StationRealm]()
        for st in stationData {
            let stRealm = StationRealm()
            stRealm.set(json: st as! [String : Any])
            print(stRealm)
//            DbHelper.shared.add(object: stRealm)
            stations.append(stRealm)

            print("======")
        }
        return stations
        
    }
    
    private func fetchStations(completion: @escaping ([Station], [StationRealm]) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            
            //            sleep(1) // TODO: Unccoment on end. 
            var stationsLocal = [Station]()
            var stationsLocalR = [StationRealm]()

            if let path = Bundle.main.path(forResource: "stationMOCList", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let stationData = jsonResult["stationData"] as? [Any] {
                        stationsLocal = self.parseDict(stationData: stationData)
                        stationsLocalR = self.parseDictRealm(stationData: stationData)
                    }
                } catch {
                    print("Error")
                }
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(stationsLocal, stationsLocalR)
            }
        }
    }
}
