//
//  UIStoryboard+Extension.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/17/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static var mainSB: UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    static var mainVC: UIViewController { return UIStoryboard.mainSB.instantiateViewController(withIdentifier:
        "MainVC_ID")}
}


