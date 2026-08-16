//
//  FetchLocationsUseCase.swift
//  Places
//

protocol FetchLocationsUseCase: Sendable {
    func execute() async throws -> [Location]
}

struct DefaultFetchLocationsUseCase: FetchLocationsUseCase {
    let repository: LocationsRepositoryProtocol

    func execute() async throws -> [Location] {
        try await repository.fetchLocations()
    }
}
