//
//  UIColor+Extension.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/17/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

extension UIColor {
    func getRandomColor() -> UIColor {
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    static var selectedStation: UIColor {
        return .red
    }
    
    static var nonSelectedStation: UIColor {
        return .green
    }
}
