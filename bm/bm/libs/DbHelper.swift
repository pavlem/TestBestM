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

//    func getFavoriteHeores() -> [HeroRealm]? {
//        return Array(realm.objects(HeroRealm.self))
//    }
//
//    func getPersistedHeroes() -> [Hero] {
//        let heroesPersisted = DbHelper.shared.getFavoriteHeores()
//
//        var heroListPersisted = [Hero]()
//        for heroP in heroesPersisted! {
//            let thumbnail = Thumbnail(path: heroP.thumbnailPath, extension: heroP.thumbnailExtension)
//
//            let hero = Hero(id: Int(heroP.id), name: heroP.name, description: nil, modified: nil, thumbnail: thumbnail, resourceURI: nil, title: nil, comics: nil, series: nil, stories: nil, events: nil)
//            heroListPersisted.append(hero)
//        }
//
//        return heroListPersisted
//    }
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
