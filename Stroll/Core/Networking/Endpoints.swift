//
//  Endpoints.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 29/06/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let body: Data?

    init(path: String,
         method: HTTPMethod = .get,
         queryItems: [URLQueryItem]? = nil,
         body: Data? = nil) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
    }
}

extension Endpoint {
    static func matchFeed(page: Int, limit: Int = 20) -> Self {
        Endpoint(
            path: "/matches/feed",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        )
    }

    static func swipeAction(userId: String, liked: Bool) -> Self {
        let body: [String: Any] = [
            "targetUserId": userId,
            "liked": liked
        ]
        return Endpoint(
            path: "/matches/swipe",
            method: .post,
            body: try? JSONSerialization.data(withJSONObject: body)
        )
    }
}
