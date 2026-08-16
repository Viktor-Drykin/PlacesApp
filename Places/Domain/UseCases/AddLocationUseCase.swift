//
//  AddLocationUseCase.swift
//  Places
//

protocol AddLocationUseCase: Sendable {
    /// Adds `location` to the repository's stored list and returns the
    /// updated list.
    func execute(_ location: Location) async -> [Location]
}

struct DefaultAddLocationUseCase: AddLocationUseCase {
    let repository: LocationsRepositoryProtocol

    func execute(_ location: Location) async -> [Location] {
        await repository.addLocation(location)
    }
}
