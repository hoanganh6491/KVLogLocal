//
//  FnBLogModel.swift
//  SimpleLocalLogStart
//
//  Created by AnhVH on 05/02/2021.
//  Copyright © 2021 anhvh. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import SwiftyUserDefaults



public class FnbLogModel: Object, Codable {
    @objc dynamic var logEvent = ""
    @objc dynamic var createdDate: Date? = nil
    @objc dynamic var orderServiceStatus = ""
    
    convenience init(json: JSON) {
        self.init()
        
        logEvent = json[LogConstants.FnbLogKey.logEvent].stringValue
        orderServiceStatus = json[LogConstants.FnbLogKey.orderServiceStatus].stringValue
        createdDate = json[LogConstants.FnbLogKey.createdDate].dateTime
    }
    
}


