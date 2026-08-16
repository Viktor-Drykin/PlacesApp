//
//  LocationsRepository.swift
//  Places
//

/// Abstraction over wherever locations come from, so the domain and
/// presentation layers never depend on networking details. Owns the current
/// list of locations — `fetchLocations()` refreshes it from the source,
/// `addLocation(_:)` appends to it — so callers always see one consistent,
/// shared list.
protocol LocationsRepository: Sendable {
    func fetchLocations() async throws -> [Location]

    /// Appends `location` to the stored list and returns the updated list.
    func addLocation(_ location: Location) async -> [Location]
}
