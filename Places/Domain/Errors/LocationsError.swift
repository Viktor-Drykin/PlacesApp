//
//  LocationsError.swift
//  Places
//

/// Domain-level failure reasons for fetching locations. Kept text-free —
/// display copy lives in the presentation layer's localization providers.
enum LocationsError: Error, Equatable {
    case server
    case decoding
    case invalidEndpoint
}
