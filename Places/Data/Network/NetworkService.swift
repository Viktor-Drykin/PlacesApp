//
//  NetworkService.swift
//  Places
//

import Foundation

enum NetworkServiceError: Error {
    case invalidResponse
}

protocol NetworkServiceProtocol: Sendable {
    func fetchData(from url: URL) async throws -> Data
}

/// Thin, domain-agnostic HTTP client — callers (repositories) own the URL
/// and translate failures into their own domain errors.
struct NetworkService: NetworkServiceProtocol {
    let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await urlSession.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.invalidResponse
        }
        return data
    }
}
