//
//  AlertHelper.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/22/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    class func presentAlert(title: String?, message: String, onViewController vc: UIViewController, confirmButtonText: String? = "OK") {
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: confirmButtonText, style: .default, handler: nil)
        avc.addAction(action)
        vc.present(avc, animated: true, completion: nil)
    }
}



