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
func getRandomInteger(maximum: Int, notAllowedInt: Int) -> Int {
    let randomInt = random(maximum)
    guard randomInt != notAllowedInt else {
        return getRandomInteger(maximum: maximum, notAllowedInt: notAllowedInt)
    }
    return randomInt
}

func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

func aprint(_ any: Any, function: String = #function, file: String = #file, line: Int = #line) {
    let fileName = file.lastPathComponent
    print("🍏\(any)- - - - - - - - - - - - - - - - - - - - - \(fileName!) || \(function) || \(line)")
}
