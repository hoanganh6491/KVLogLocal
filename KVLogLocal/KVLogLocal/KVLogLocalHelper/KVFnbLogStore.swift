//
//  KVFnbLogStore.swift
//  SimpleLocalLogStart
//
//  Created by AnhVH on 05/02/2021.
//  Copyright © 2021 anhvh. All rights reserved.
//

import Foundation
import RealmSwift

class KVFnbLogStore: LogBaseStore {
    static let shared = KVFnbLogStore()
    
    func getLogs() -> [FnbLogModel] {
        return (self.getListObjects() as Results<FnbLogModel>).map { $0 }
    }
    
    func saveLog (logEvent: FnbLogModel) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(logEvent)
        try! realm.commitWrite()
    }
    
    func clearLogAll () {
        let realm = try! Realm()
        let results: Results<FnbLogModel> = self.getListObjects()
        realm.beginWrite()
        realm.delete(results)
        try! realm.commitWrite()
    }
    
    func clearLogToGivenTime (date: Date) {
        let results: Results<FnbLogModel> = self.getListObjects().filter("createdDate <= %@", date)
        realm.beginWrite()
        realm.delete(results)
        try! realm.commitWrite()
    }
}
