//
//  HelperFunctions.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/18/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import MapKit

// Utility
func getRandomInteger(maximum: Int, notAllowedInt: Int) -> Int { //TODO: Unit Test
    let randomInt = random(maximum)
    guard randomInt != notAllowedInt else {
        return getRandomInteger(maximum: maximum, notAllowedInt: notAllowedInt)
    }
    return randomInt
}

func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}
