//
//  LogBaseStore.swift
//  SimpleLocalLogStart
//
//  Created by AnhVH on 05/02/2021.
//  Copyright © 2021 anhvh. All rights reserved.
//

import Foundation
import RealmSwift

protocol LogBaseStore: AnyObject {
    var realm: Realm { get }
    
    func add<T: Object>(_ object: T, update: Realm.UpdatePolicy)
    
    func getObject<T: Object, KeyType>(withID id: KeyType) -> T?
    
    func getListObjects<T: Object>() -> Results<T>
    
    func delete<T: Object>(object: T)
    
    func add<T: Object>(_ objects: [T], update: Realm.UpdatePolicy)
}

extension LogBaseStore {
    var realm: Realm {
        return try! Realm()
    }
    
    func add<T: Object>(_ object: T, update: Realm.UpdatePolicy = .all)  {
        try! realm.write {
            realm.add(object, update: update)
        }
    }
    
    func getObject<T: Object, KeyType>(withID id: KeyType) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func getListObjects<T: Object>() -> Results<T> {
        return realm.objects(T.self)
    }
    
    func delete<T: Object>(object: T) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func add<T: Object>(_ objects: [T], update: Realm.UpdatePolicy = .all)  {
        try! realm.write {
            realm.add(objects, update: update)
        }
    }
}
