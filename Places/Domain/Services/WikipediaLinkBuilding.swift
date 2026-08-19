//
//  WikipediaLinkBuilding.swift
//  Places
//

import Foundation

protocol WikipediaLinkBuilder: Sendable {
    func url(for coordinate: Coordinate) -> URL?
}

/// Builds deep links into the companion Wikipedia app, e.g.
/// `wikipedia://places?lat=52.3676&lon=4.9041`.
struct WikipediaDeepLinkBuilder: WikipediaLinkBuilder {
    func url(for coordinate: Coordinate) -> URL? {
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
        ]
        return components.url
    }
}
