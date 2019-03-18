//
//  DBManager.swift
//  Jasy
//
//  Created by Vladimir Espinola on 3/18/19.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    private var database: Realm
    static let shared = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromDB() ->   Results<ApodModel> {
        let results: Results<ApodModel> = database.objects(ApodModel.self)
        return results
    }
    
    func add(object: ApodModel)   {
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
    }
    func deleteAllFromDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    func deleteFromDb(object: ApodModel)   {
        try! database.write {
            database.delete(object)
        }
    }
}
