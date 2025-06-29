//
//  Untitled.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 29/06/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case unauthorized
    case notFound
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let error): return "Request failed: \(error.localizedDescription)"
        case .invalidResponse: return "Invalid server response"
        case .decodingFailed(let error): return "Decoding error: \(error.localizedDescription)"
        case .unauthorized: return "Authentication required"
        case .notFound: return "The requested resource was not found."
        case .serverError(let code): return "Server error (\(code))"
        }
    }
}

extension JSONDecoder {
    static let custom: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
