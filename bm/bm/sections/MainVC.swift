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
        
        fetchStations { (stations) in
            DispatchQueue.main.async {
                //                self.persistStations(stationsRealm: stationsRealm)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                
                
                
                let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.mapVC) as! MapVC
                mapVC.set(navigationTitle: "Map List")
                mapVC.set(stations: stations)
                self.show(mapVC, sender: nil)
            }

        }
        
//        fetchStations { (stationsRealm) in
//            DispatchQueue.main.async {
////                self.persistStations(stationsRealm: stationsRealm)
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                self.showMapVC()
//            }
//        }
    }
    
    // MARK: - Helper
    private func persistStations(stationsRealm: [StationRealm]) {
        DbHelper.shared.persist(stations: stationsRealm)
    }
    
    private func showMapVC() {
        let stationsRealm = DbHelper.shared.fetchAllStationsFromDB()
        let stations = ParserHelper.getStationObjectsFrom(stationsRealm: stationsRealm)
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.mapVC) as! MapVC
        mapVC.set(navigationTitle: "Map List")
        mapVC.set(stations: stations)
        self.show(mapVC, sender: nil)
    }
    
    private func fetchRealmStations(completion: @escaping ([StationRealm]) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            //            sleep(1)
            ParserHelper.getDataFromLocalJSON(completion: { (stationsRealm) in
                completion(stationsRealm)
            })
        }
    }
    
    private func fetchStations(completion: @escaping ([Station]) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            //            sleep(1)
            ParserHelper.getDataFromLocalJSON(completion: { (stations) in
                completion(stations)
            })
        }
    }
}
