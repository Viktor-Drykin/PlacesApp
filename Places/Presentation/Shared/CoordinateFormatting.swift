//
//  CoordinateFormatting.swift
//  Places
//

import Foundation

/// Formats a `Coordinate` for display, e.g. "52.3547° N, 4.8339° E". This is
/// locale-specific text, so it lives in the presentation layer — each
/// screen's localization provider calls into this shared helper rather than
/// duplicating the N/S/E/W logic.
enum CoordinateFormatting {
    static func format(_ coordinate: Coordinate) -> String {
        let ns = coordinate.latitude >= 0
            ? String(localized: "coordinate.direction.north", defaultValue: "N")
            : String(localized: "coordinate.direction.south", defaultValue: "S")
        let ew = coordinate.longitude >= 0
            ? String(localized: "coordinate.direction.east", defaultValue: "E")
            : String(localized: "coordinate.direction.west", defaultValue: "W")
        let latText = String(format: "%.4f", abs(coordinate.latitude))
        let lonText = String(format: "%.4f", abs(coordinate.longitude))
        return String(localized: "coordinate.formatted", defaultValue: "\(latText)° \(ns), \(lonText)° \(ew)")
    }
}
