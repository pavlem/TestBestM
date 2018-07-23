//
//  ParserHelper.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/23/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ParserHelper {
    
//     MARK: - Parsing to Station objects - if needed
    class func parseDict(stationData: [Any]) -> [Station] {
        var stations = [Station]()
        for st in stationData {
            let stationObj = Station(json: st as! [String : Any])
            stations.append(stationObj)
        }
        return stations
    }
    
    // MARK: - Parsing to Station Realm objects
    class func parseDictionaryToRealmObject(stationData: [Any]) -> [StationRealm] {
        var stations = [StationRealm]()
        for st in stationData {
            let stRealm = StationRealm()
            stRealm.set(json: st as! [String : Any])
            stations.append(stRealm)
        }
        return stations
    }
    
    class func getStationObjectsFrom(stationsRealm: [StationRealm]) -> [Station] {
        var stations = [Station]()
        for stRealm in stationsRealm {
            let st = Station(stationRealm: stRealm)
            stations.append(st)
        }
        return stations
    }
    
    class func getDataFromLocalJSON(completion: ([StationRealm]) -> Void) {
        var stationsRealm = [StationRealm]()
        if let path = Bundle.main.path(forResource: "stationMOCList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let stationDictionaryData = jsonResult["stationData"] as? [Any] {
                    stationsRealm = self.parseDictionaryToRealmObject(stationData: stationDictionaryData)
                    completion(stationsRealm)
                }
            } catch {
                print("Error")
            }
        }
    }
    
    class func getDataFromLocalJSON(completion: ([Station]) -> Void) {
        var stations = [Station]()
        if let path = Bundle.main.path(forResource: "stationMOCList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let stationDictionaryData = jsonResult["stationData"] as? [Any] {
                    stations = self.parseDict(stationData: stationDictionaryData)
                    completion(stations)
                }
            } catch {
                print("Error")
            }
        }
    }
}
