//
//  KVFnbLogConstant.swift
//  KVLogLocal
//
//  Created by AnhVH on 18/02/2021.
//  Copyright © 2021 anhvh. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct LogConstants {
    
    struct Directory {
        static let logs = "Logs"
    }
    
    struct FnbLogKey {
        
        static let logInfo = "logInfo"
        static let logHistory = "logHistory"
        
        static let timeIntervalChecked = DefaultsKey<Date?>("timeIntervalChecked")
        
        static let logEvent             = "logEvent"
        static let createdDate          = "createdDate"
        static let orderServiceStatus   = "orderServiceStatus"
        
        static let agentID              = "agentID"
        static let agentSyncStatus      = "agentSyncStatus"
        static let IpAddress            = "IpAddress"
        static let appVersion           = "appVersion"
        static let deviceModel          = "deviceModel"
        static let deviceIosVersion     = "deviceIosVersion"
    }
}

