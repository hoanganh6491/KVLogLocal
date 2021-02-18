//
//  KVFnbLogUtils.swift
//  SimpleLocalLogStart
//
//  Created by AnhVH on 08/02/2021.
//  Copyright © 2021 anhvh. All rights reserved.
//

import Foundation
import SwiftyJSON

class Utils {
    static func dateWithISO8601String(timeString: String) -> Date? {
        if timeString.isEmpty {
            return nil
        }
        var iso8601String = timeString
        if !timeString.contains("+") && !timeString.lowercased().contains("z") {
            iso8601String = timeString + "+07:00"
        }
        if let parseDate = Date(iso8601String: iso8601String) {
            return parseDate
        }
        
        return nil
    }
}

public extension Date {
    /// SwifterSwift: Create date object from ISO8601 string.
    ///
    ///     let date = Date(iso8601String: "2017-01-12T16:48:00.959Z") // "Jan 12, 2017, 7:48 PM"
    ///
    /// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
    init?(iso8601String: String) {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        
        if let date = iso8601String.date(inFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
            self = date
        } else if let date = iso8601String.date(inFormat: "yyyy-MM-dd'T'HH:mm:ssZ") {
            self = date
        } else {
            return nil
        }
    }
}

extension Date {
    
    /// Returns number of days between two date
    func difDays(from date: Date) -> Int {
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: date)
        let date2 = calendar.startOfDay(for: self)
        return calendar.dateComponents([.day], from: date1, to: date2).day ?? 0
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension String {
    /// Creates a `Date` instance representing the receiver parsed into `Date` in a given format.
    ///
    /// - parameter format: The format to be used to parse.
    ///
    /// - returns: The created `Date` instance.
    public func date(inFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: self)
    }
    
    /// Creates a `Date` instance representing the receiver in ISO8601 format parsed into `Date` with given options.
    ///
    /// - parameter options: The options to be used to parse.
    ///
    /// - returns: The created `Date` instance.
    @available(iOS 10.0, OSX 10.12, watchOS 3.0, tvOS 10.0, *)
    public func dateInISO8601Format(with options: ISO8601DateFormatter.Options = [.withInternetDateTime]) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = options
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: self)
    }
}

extension JSON {
    public var dateTime: Date? {
        get {
            switch self.type {
            case .string:
                return Utils.dateWithISO8601String(timeString: self.stringValue)
            default:
                return nil
            }
        }
    }
}


extension FileManager {
    
    /// Đường dẫn đến thư mục Documents của ứng dụng
    var documentDirectoryPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    /// Đường dẫn đến thư mục chứa Logs của ứng dụng
    var logDirectoryPath: String {
        return documentDirectoryPath.appendingPathComponent(LogConstants.Directory.logs)
    }
    
    func createDirectoryIfNeeded(path: URL) {
        if !fileExists(atPath: path.path) {
            do {
                try createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                KVFnbLogHelper.shared.saveLogLocal(eventLog: "Could not create directory at path \(path). Error: \(error)")
            }
        }
    }
    
    /// Xóa file tại /logs
    func clearLogsFolder() {
        let fileManager = FileManager.default
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: logDirectoryPath)
            for path in filePaths {
                let fullPath = logDirectoryPath.appendingPathComponent(path)
                try fileManager.removeItem(atPath: fullPath)
            }
        } catch let error as NSError {
            KVFnbLogHelper.shared.saveLogLocal(eventLog: "Không xóa được thư mục Logs! Lỗi: \(error)")
            
        }
    }
}

//MARK: - NSString extensions
public extension String {
    
    /// SwifterSwift: NSString appendingPathComponent(str: String)
    ///
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    public func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    /// SwifterSwift: NSString appendingPathExtension(str: String)
    ///
    /// - Parameter str: The extension to append to the receiver.
    /// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
    public func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
}
