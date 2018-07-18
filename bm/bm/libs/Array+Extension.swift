//
//  Array+Extension.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/18/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
extension Array {
    func extractArrayElements(withStep step: Int) -> [Any] {
        
        let arrayLo = self.enumerated().filter { index, element in
            return index % step == 0
            }.map { index, element in
                return element
        }
        
        return arrayLo
    }
}
