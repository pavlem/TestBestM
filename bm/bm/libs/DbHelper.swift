//
//  DbHelper.swift
//  bm
//
//  Created by Pavle Mijatovic on 7/15/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import RealmSwift

var realm = try! Realm()

let realmFolderName = "realmDB"
let realmFileName = "bestmile.realm"
let schemaVersionNumberToDelete = 3

class DbHelper {
    
    static let shared = DbHelper()
    
    // MARK: - Properties
    // MARK: Writing Objects
    func deleteAllDBObjects() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func add(object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let err {
            print(err)
        }
    }
    
    func update(object: Object) {
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch let err {
            print(err)
        }
    }
    
    func delete(object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let err {
            print(err)
        }
    }
    
    func startRealmDBInstance() {
        do {
            realm = try Realm()
        } catch let err {
            print(err)
        }
    }
}

// MARK: - Heroes
extension DbHelper {
    
    func persist(stations: [StationRealm]) {
        for s in stations {
            if let station = realm.object(ofType: StationRealm.self, forPrimaryKey: s.id) {
                self.update(object: station)
            } else {
                self.add(object: s)
            }
        }
    }

    func fetchAllStationsFromDB() -> [StationRealm] {
        return Array(realm.objects(StationRealm.self))
    }
}

// MARK: - Project related
extension DbHelper {
    func setRealmConfig() {
        var config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, oldSchemaVersion in

                if oldSchemaVersion < 1 {
                    print("oldSchemaVersion: \(oldSchemaVersion)")
                    // Perform 1 Migration Block - this is for potential migrations
                }
        })

        config.deleteRealmIfMigrationNeeded = config.schemaVersion < UInt64(schemaVersionNumberToDelete)
        config.fileURL = URL(string: realmDBFileLocation(fileName: realmFileName))
        Realm.Configuration.defaultConfiguration = config
    }

    func realmDBFileLocation(fileName: String) -> String {
        let realmDBFolderPath = FileManager.documentsDir() + "/" + realmFolderName

        if !FileHelper.fileExists(atPath: realmDBFolderPath) {
            FileHelper.createDirectoryAtPath(realmDBFolderPath)
        }
        _ = FileHelper.skipCloudBackup(path: realmDBFolderPath)
        return FileManager.documentsDir() + "/\(realmFolderName)/\(fileName)"
    }
}
