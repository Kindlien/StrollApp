//
//  AppEnvironment.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 29/06/25.
//

import Foundation

enum AppEnvironment {
    case production
    case development

    static var current: AppEnvironment {
        #if PRODUCTION
        return .production
        #elseif DEVELOPMENT
        return .development
        #endif
    }

    var baseURL: String {
        switch self {
        case .production: return "https://api.stroll.com"
        case .development: return "https://dev.api.stroll.com"
        }
    }
}
