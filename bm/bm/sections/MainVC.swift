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
    @IBOutlet weak var feedbackLbl: UILabel!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
    }
    
    // MARK: - Actions
    @IBAction func getStations(_ sender: UIButton) {
        getStationsBtn.isEnabled = false
        feedbackLbl.isHidden = true
        
        fetchStations { (stationsRealm) in
            DispatchQueue.main.async {
                self.persistStations(stationsRealm: stationsRealm)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.showMapVC()
            }
        }
    }
    
    // MARK: - Helper
    private func setUI() {
        feedbackLbl.isHidden = true
        getStationsBtn.isEnabled = true
        getStationsBtn.setTitle("getStations".localized, for: .normal)
    }
    
    private func persistStations(stationsRealm: [StationRealm]) {
        DbHelper.shared.persist(stations: stationsRealm)
    }
    
    private func showMapVC() {
        let stationsRealm = DbHelper.shared.fetchAllStationsFromDB()
        let stations = ParserHelper.getStationObjectsFrom(stationsRealm: stationsRealm)
        let mapVC = UIStoryboard.mapVC as! MapVC
        mapVC.set(navigationTitle: "mapList".localized)
        mapVC.set(stations: stations)
        self.show(mapVC, sender: nil)
    }
    
    private func fetchStations(completion: @escaping ([StationRealm]) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        feedbackLbl.text = "fetchingPleaseWait".localized
        feedbackLbl.isHidden = false

        DispatchQueue.global(qos: .background).async {
            sleep(1)
            ParserHelper.getDataFromLocalJSON(completion: { (stationsRealm) in
                completion(stationsRealm)
            })
        }
    }
}
