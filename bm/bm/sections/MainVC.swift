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
        }
    }
    
    // MARK: - Helper
    private func fetchStations(completion: @escaping () -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion()
            }
        }
    }
}
