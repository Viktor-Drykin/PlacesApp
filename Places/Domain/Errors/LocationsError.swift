//
//  LocationsError.swift
//  Places
//

/// Domain-level failure reasons for fetching locations. Kept text-free —
/// display copy lives in the presentation layer's localization providers.
enum LocationsError: Error, Equatable {
    case network
    case decoding
    case invalidEndpoint
    case unknown
}
