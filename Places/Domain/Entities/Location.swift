//
//  Location.swift
//  Places
//

import Foundation

struct Location: Identifiable, Equatable, Hashable, Sendable {
    let id: String
    /// `nil` when the source data has no name for this location — display
    /// fallback text is a presentation-layer concern.
    let name: String?
    let coordinate: Coordinate

    init(id: String, name: String?, coordinate: Coordinate) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
    }
}
