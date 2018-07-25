//
//  StationRealm.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/23/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class StationRealm: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    override class func primaryKey() -> String {
        return "id"
    }

    // MARK: - API
    func set(json: [String: Any]) {
        id = json["stationId"] as? String ?? "-1"
        name = json["name"] as? String ?? ""
        type = json["type"] as? String ?? ""
        latitude = json["latitude"] as? Double ?? 0.0
        longitude = json["longitude"] as? Double ?? 0.0
    }
    
//    init(json: [String: Any]) {
//        id = json["stationId"] as? String ?? "-1"
//        name = json["name"] as? String ?? ""
//        type = json["type"] as? String ?? ""
//        latitude = json["latitude"] as? Double ?? 0.0
//        longitude = json["longitude"] as? Double ?? 0.0
//    }

}


//class Station: NSObject {
//    let id: String
//    let name: String
//    let type: String
//    let location: CLLocation
//
//    init(json: [String: Any]) {
//        id = json["stationId"] as? String ?? "-1"
//        name = json["name"] as? String ?? ""
//        type = json["type"] as? String ?? ""
//        let latitude = json["latitude"] as? Double ?? 0.0
//        let longitude = json["longitude"] as? Double ?? 0.0
//        location = CLLocation(latitude: latitude, longitude: longitude)
//    }
//
//    init(id: String, name: String, type: String, latitude: Double, longitude: Double) {
//        self.id = id
//        self.name = name
//        self.type = type
//        self.location = CLLocation(latitude: latitude, longitude: longitude)
//    }
//}
