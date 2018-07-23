//
//  StatisticView.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/23/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class StatisticView: UIView {

    @IBOutlet weak var statsTitle: UILabel!
    @IBOutlet weak var currentVehicleNo: UILabel!
    @IBOutlet weak var totalVehicleNo: UILabel!
    @IBOutlet weak var totalVehicleTimeSpent: UILabel!
    
    var statistics: Statistics! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        statsTitle.text = statistics.title
        currentVehicleNo.text = "currentNumberOfVehicles: " + String(statistics.currentNumberOfVehicles)
        totalVehicleNo.text = "totalNumberOfVehiclesCreated: " + String(statistics.totalNumberOfVehiclesCreated)
        totalVehicleTimeSpent.text = "totalTimeInSeconds: " + String(statistics.totalTimeInSeconds)
    }
}
