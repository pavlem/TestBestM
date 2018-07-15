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
    // Vars
    var stations = [Station]()
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
        
        fetchStations {
            //            let sb = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = sb.instantiateViewController(withIdentifier: "MapVC_ID")
            //            self.show(vc, sender: nil)
            
            self.performSegue(withIdentifier: Segue.mapVC, sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mapVC = segue.destination as? MapVC {
            mapVC.set(navigationTitle: "Map List")
            mapVC.set(stations: stations)
        }
    }
    
    // MARK: - Helper
    private func fetchStations(completion: @escaping () -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            
            let st1 = Station(name: "Station 1", type: "Driverless bus", lat: 46.517202, long: 6.629205)
            let st2 = Station(name: "Station 2", type: "Driverless bus", lat: 46.541050, long: 6.658185)
            let st3 = Station(name: "Station 3", type: "Driverless bus", lat: 46.541724, long: 6.618336)
            let st4 = Station(name: "Station 4", type: "Driverless bus", lat: 46.522044, long: 6.565975)
            let st5 = Station(name: "Station 5", type: "Driverless bus", lat: 46.511076, long: 6.659613)
    
            self.stations = [st1, st2, st3, st4, st5]
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion()
            }
        }
    }
}
