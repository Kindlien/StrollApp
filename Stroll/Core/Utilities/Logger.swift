//
//  Logger.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 29/06/25.
//

import os.log
import Foundation

struct Logger {
    static func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEVELOPMENT
        let fileName = (file as NSString).lastPathComponent
        os_log("%{public}@: %{public}@", log: OSLog.default, type: level.osLogType, "\(fileName):\(line)", message)
        #endif
    }
}

enum LogLevel {
    case debug, info, warning, error

    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        }
    }
}
