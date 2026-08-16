//
//  LocationsService.swift
//  Places
//

import Foundation

protocol LocationsServiceProtocol: Sendable {
    func fetchLocations() async throws -> [Location]
}

/// Fetches and decodes the remote locations payload. Stateless — owning the
/// resulting list is `LocationRepository`'s job, not this service's.
struct LocationsService: LocationsServiceProtocol {
    private static let endpointString = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"

    let networkService: NetworkServiceProtocol
    let decoder: JSONDecoder

    init(networkService: NetworkServiceProtocol, decoder: JSONDecoder) {
        self.networkService = networkService
        self.decoder = decoder
    }

    func fetchLocations() async throws -> [Location] {
        guard let endpoint = URL(string: Self.endpointString) else {
            throw LocationsError.invalidEndpoint
        }

        let data: Data
        do {
            data = try await networkService.fetchData(from: endpoint)
        } catch {
            throw LocationsError.network
        }

        do {
            let response = try decoder.decode(LocationsResponseDTO.self, from: data)
            return response.locations.map { $0.toDomain() }
        } catch {
            throw LocationsError.decoding
        }
    }
}
