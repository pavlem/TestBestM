//
//  StatisticView.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/23/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class StatisticView: UIView {
    
    // MARK: - API
    func animateShowingOfStatsView(_ isShown: Bool) {
        if isShown {
            self.isHidden = true
            self.alpha = 0
        } else {
            self.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.alpha = 0.5
            }
        }
    }
    
    var statistics: Statistics! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Properties
    @IBOutlet weak var statsTitle: UILabel!
    @IBOutlet weak var currentVehicleNo: UILabel!
    @IBOutlet weak var totalVehicleNo: UILabel!
    @IBOutlet weak var totalVehicleTimeSpent: UILabel!
    
    // MARK: - Private
    private func updateUI() {
        statsTitle.text = statistics.title
        currentVehicleNo.text = "currentNumberOfVehicles".localized + String(statistics.currentNumberOfVehicles)
        totalVehicleNo.text = "totalNumberOfVehiclesCreated".localized + String(statistics.totalNumberOfVehiclesCreated)
        totalVehicleTimeSpent.text = "totalTimeInSeconds".localized + String(statistics.totalTimeInSeconds) + "s"
    }
}
