//
//  String+Extension.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/31/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation

// MARK: Localized
extension String {
    var localized: String {
        return localizedWithComment(comment: "")
    }
    
    func localizedWithComment(comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
}

extension String {
    var ns: NSString {
        return self as NSString
    }
    var pathExtension: String? {
        return ns.pathExtension
    }
    var lastPathComponent: String? {
        return ns.lastPathComponent
    }
}
