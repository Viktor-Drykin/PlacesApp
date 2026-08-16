//
//  LocationsServiceTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

private struct FakeNetworkService: NetworkServiceProtocol {
    enum Behavior {
        case success(Data)
        case failure(Error)
    }

    let behavior: Behavior

    func fetchData(from url: URL) async throws -> Data {
        switch behavior {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
}

struct LocationsServiceTests {
    @Test func mapsValidJSONToLocations() async throws {
        let json = """
        { "locations": [ { "name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215 } ] }
        """.data(using: .utf8)!
        let service = LocationsService(networkService: FakeNetworkService(behavior: .success(json)), decoder: JSONDecoder())

        let locations = try await service.fetchLocations()

        #expect(locations.count == 1)
        #expect(locations[0].name == "Amsterdam")
    }

    @Test func propagatesNetworkErrors() async {
        let service = LocationsService(networkService: FakeNetworkService(behavior: .failure(LocationsError.network)), decoder: JSONDecoder())

        await #expect(throws: LocationsError.network) {
            _ = try await service.fetchLocations()
        }
    }

    @Test func translatesMalformedJSONToDecodingError() async {
        let malformed = "{ not json ".data(using: .utf8)!
        let service = LocationsService(networkService: FakeNetworkService(behavior: .success(malformed)), decoder: JSONDecoder())

        await #expect(throws: LocationsError.decoding) {
            _ = try await service.fetchLocations()
        }
    }
}
