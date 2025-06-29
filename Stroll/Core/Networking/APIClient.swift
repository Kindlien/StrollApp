//
//  APIClient.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 29/06/25.
//

import Combine
import Foundation

class APIClient {
    private let baseURL: URL
    private let requestInterceptor: RequestInterceptor

    init(baseURL: URL, interceptor: RequestInterceptor = RequestInterceptor()) {
        self.baseURL = baseURL
        self.requestInterceptor = interceptor
    }

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        guard var urlComponents = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: true
        ) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request = requestInterceptor.adapt(request)

        return URLSession.shared.dataTaskPublisher(for: request)
                   .tryMap { data, response in
                       guard let httpResponse = response as? HTTPURLResponse else {
                           throw NetworkError.invalidResponse
                       }
                       switch httpResponse.statusCode {
                       case 200...299:
                           return data
                       case 401:
                           throw NetworkError.unauthorized
                       case 404:
                           throw NetworkError.notFound
                       case 400...499:
                           print("Client error \(httpResponse.statusCode): \(String(data: data, encoding: .utf8) ?? "No error message")")
                           throw NetworkError.requestFailed(NSError(domain: "HTTPClientError", code: httpResponse.statusCode, userInfo: nil))
                       case 500...599:
                           throw NetworkError.serverError(httpResponse.statusCode)
                       default:
                           throw NetworkError.requestFailed(NSError(domain: "HTTPUnknownError", code: httpResponse.statusCode, userInfo: nil))
                       }
                   }

            .decode(type: T.self, decoder: JSONDecoder.custom)
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return .requestFailed(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
