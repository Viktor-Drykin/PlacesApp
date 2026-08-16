//
//  LocationDTO+Mapping.swift
//  Places
//

import Foundation

extension LocationDTO {
    /// Maps to the domain entity, preserving `nil`/blank names as `nil`.
    /// Deciding what to display instead is a presentation-layer concern.
    func toDomain() -> Location {
        let coordinate = Coordinate(latitude: lat, longitude: long)
        let trimmedName = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        return Location(
            id: "\(lat),\(long)",
            name: (trimmedName?.isEmpty == false) ? trimmedName : nil,
            coordinate: coordinate
        )
    }
}
