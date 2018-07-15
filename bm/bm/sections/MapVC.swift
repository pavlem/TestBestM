//
//  MapVC.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class MapVC: UIViewController {
    
    // MARK: - API
    func set(navigationTitle: String) {
        navigationItem.title = navigationTitle
    }
    
    func set(stations: [Station]) {
        self.stations = stations
    }

    // MARK: - Properties
    private var stations: [Station]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(stations?.count ?? 0)
    }
}
