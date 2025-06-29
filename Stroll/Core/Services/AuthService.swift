//
//  AuthService.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 29/06/25.
//

import Foundation
import Security

class AuthService {
    static let shared = AuthService()
    private(set) var authToken: String?

    private init() {
        authToken = KeychainService.loadToken()
    }

    func saveAuthToken(_ token: String) {
        authToken = token
        KeychainService.save(token: token)
    }

    func getAuthToken() -> String? {
        authToken = KeychainService.loadToken()
        return authToken
    }

    func clearAuthToken() {
        authToken = nil
        KeychainService.deleteToken()
    }
}

struct KeychainService {
    private static let serviceName = "com.stroll.auth"

    static func save(token: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecValueData as String: token.data(using: .utf8)!
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    static func loadToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)

        guard status == errSecSuccess,
              let tokenData = data as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            return nil
        }

        return token
    }

    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName
        ]

        SecItemDelete(query as CFDictionary)
    }
}
