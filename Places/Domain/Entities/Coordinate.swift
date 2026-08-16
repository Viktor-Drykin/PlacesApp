//
//  Coordinate.swift
//  Places
//

import Foundation

/// Raw coordinate data only — formatting it for display is locale-specific
/// and belongs in the presentation layer's localization providers.
struct Coordinate: Equatable, Hashable, Sendable {
    let latitude: Double
    let longitude: Double
}
