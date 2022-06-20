//
//  DatabaseManager.swift
//  Giffy
//
//  Created by Manish Tamta on 24/05/2022.
//

import Foundation
import RealmSwift

enum SaveType: String {
    case trendingGif = "TrendingGif"
}

protocol DBManagerView {
    func removeAllTrendingGiffData()
    func saveGiffyList(trendingList : TrendingGIFModelList)
    func fetchTrendingList(_ completion: @escaping ((APIResult<TrendingGIFModelList, Error>) -> Void))
}

class DatabaseManager: DBManagerView {
    
    var type: SaveType
    
    init(type: SaveType) {
        self.type = type
    }
    
    var trendingGiffyRealm: Realm {
        // Open the realm with a specific file URL, for example a username
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(type.rawValue)
        config.fileURL!.appendPathExtension("realm")
        let realm = try! Realm(configuration: config)
        return realm
    }
    
    //Remove all stored TrendingGiff Data from storage
    func removeAllTrendingGiffData() {
        do {
            try trendingGiffyRealm.write {
                trendingGiffyRealm.deleteAll()
            }
        } catch let error as NSError {
            // Handle error
            print(error)
        }
    }
    
    //Save the updated or new TrendingList
    func saveGiffyList(trendingList : TrendingGIFModelList){
        do {
            let storableTrendingList = trendingList.compactMap{ ($0).toStorable() }

            try  trendingGiffyRealm.write {
                trendingGiffyRealm.add(storableTrendingList)
            }
        } catch let error as NSError {
            // Handle error
            print("Error saving forecast data")
            print(error)
        }
    }
    
    //Fetch saved TrendingList from database
    func fetchTrendingList(_ completion: @escaping ((APIResult<TrendingGIFModelList, Error>) -> Void)){
        // Open the local-only default realm
        let storableTrendingList = trendingGiffyRealm.objects(StorableTrendingGIFModel.self)
        let trendingList = storableTrendingList.compactMap{ ($0).model }
        completion(.success(Array(trendingList)))
    }
}
