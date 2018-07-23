//
//  FileHelper.swift
//  bm
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

let fileManager = FileManager.default

class FileHelper {
    
    class func fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    class func skipCloudBackup(path: String) -> Bool {
        let url: Foundation.URL = URL(fileURLWithPath: path)
        
        assert(FileManager.default.fileExists(atPath: path), "File \(path) does not exist")
        
        var success: Bool
        do {
            try (url as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
            success = true
        } catch let error as NSError {
            success = false
            print("Error excluding \(url.lastPathComponent) from backup \(error)")
        }
        
        return success
    }
    
    class func createDirectoryAtPath(_ path: String) {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

extension FileManager {
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}
