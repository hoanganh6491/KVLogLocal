//
//  KVFnbLogHelper.swift
//  SimpleLocalLogStart
//
//  Created by AnhVH on 05/02/2021.
//  Copyright © 2021 anhvh. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Alamofire

public class KVFnbLogHelper: NSObject {
    public static let shared = KVFnbLogHelper()
    
    enum OrderServiceEndpointStatus : String {
        case Reached = "Reached"
        case Unknow = "Unknown"
        case NotReachable = "NotReachable"
    }
    var hostName = ""
    var orderServiceEndpointStatus = OrderServiceEndpointStatus.Unknow
    var reachabilityManager : NetworkReachabilityManager?
    
    override init() {
        super.init()
    }
    
    // MARK: - Setting
    
    public func settingNetworkReacher (_ host: String) {
        self.hostName = host
        if reachabilityManager == nil {
            reachabilityManager = NetworkReachabilityManager(host: hostName)
        }
        reachabilityManager?.listener = { status in
            self.handleNetworkStatus(status: status)
        }
        reachabilityManager?.startListening()
    }
    
    public func verifyLogHelper () {
        guard let previousTime = Defaults[LogConstants.FnbLogKey.timeIntervalChecked] else {
            // first time deploying Log
            Defaults[LogConstants.FnbLogKey.timeIntervalChecked] = Date()
            return
        }
        let days = Date().difDays(from: previousTime)

        if days > 1 {
            // clear log on the day before
            let toDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            KVFnbLogStore.shared.clearLogToGivenTime(date: toDate)
            self.deleteLogFile()
        }
    }
    
    // MARK: - Handler
    
    public func getAllLog () -> [FnbLogModel] {
        return KVFnbLogStore.shared.getLogs()
    }
    
    public func saveLogLocal (eventLog: String) {
        let fnbLog = FnbLogModel()
        fnbLog.logEvent = eventLog
        fnbLog.orderServiceStatus = self.orderServiceEndpointStatus.rawValue
        if self.orderServiceEndpointStatus != .Reached {
            self.reachabilityManager = NetworkReachabilityManager(host: hostName)
        }
        fnbLog.createdDate = Date()
        KVFnbLogStore.shared.saveLog(logEvent: fnbLog)
    }
    
    // MARK: - Utils
    public func dataFilePathLogs (fileName: String) -> String {
        return FileManager.default.logDirectoryPath.appendingFormat("\(fileName)")
    }
    
    public func writeToReportFile (params: Dictionary<String, Any>) -> URL {
        // get logs from db
        let logs = self.getAllLog()
        
        let path = URL(fileURLWithPath: dataFilePathLogs(fileName: "/logs.txt"))
        do {
            let logEncoded = try JSONEncoder().encode(logs)
            
            var data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            data.append(logEncoded)
            do {
                try data.write(to: path)
            }
            catch {
                KVFnbLogHelper.shared.saveLogLocal(eventLog: "Failed to write logs: \(error.localizedDescription)")
                
            }
        } catch {
            KVFnbLogHelper.shared.saveLogLocal(eventLog: "Failed to encode logs: \(error.localizedDescription)")
            
        }
        return path
    }
    
    public func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public func deleteLogFile () {
        let fileManager = FileManager.default
        do {
            let filePath = URL(fileURLWithPath: dataFilePathLogs(fileName: "/logs.txt"))
            try fileManager.removeItem(at: filePath)
        } catch {
            
        }
    }
    
    public func getInfos (params: FnbLogModel) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public func handleNetworkStatus(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
        case .notReachable:
            self.orderServiceEndpointStatus = .NotReachable
            reachabilityManager = NetworkReachabilityManager(host: hostName)
            break
        case .unknown:
            self.orderServiceEndpointStatus = .Unknow
            break
        case .reachable:
            self.orderServiceEndpointStatus = .Reached
            break
        }
    }
}

