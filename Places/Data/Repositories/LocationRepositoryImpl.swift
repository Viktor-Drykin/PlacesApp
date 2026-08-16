//
//  LocationRepositoryImpl.swift
//  Places
//

/// Owns the current list of locations. Fetches it from `LocationsService`
/// and keeps it in memory, so that locations added by the user live
/// alongside the ones fetched remotely. An actor so concurrent
/// fetch/add calls mutate `storedLocations` safely.
actor LocationRepositoryImpl: LocationsRepository {
    private let locationsService: LocationsServiceProtocol
    private var storedLocations: [Location] = []

    init(locationsService: LocationsServiceProtocol) {
        self.locationsService = locationsService
    }

    func fetchLocations() async throws -> [Location] {
        storedLocations = try await locationsService.fetchLocations()
        return storedLocations
    }

    func addLocation(_ location: Location) async -> [Location] {
        storedLocations.append(location)
        return storedLocations
    }
}
