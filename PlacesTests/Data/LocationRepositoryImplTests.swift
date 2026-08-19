//
//  LocationRepositoryTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

private struct FakeLocationsService: LocationsServiceProtocol {
    enum Behavior {
        case success([Location])
        case failure(Error)
    }

    let behavior: Behavior

    func fetchLocations() async throws -> [Location] {
        switch behavior {
        case .success(let locations): return locations
        case .failure(let error): throw error
        }
    }
}

struct LocationRepositoryTests {
    private let amsterdam = Location(id: UUID().uuidString, name: "Amsterdam", coordinate: Coordinate(latitude: 52.3547498, longitude: 4.8339215))
    private let kyoto = Location(id: UUID().uuidString, name: "Kyoto Station", coordinate: Coordinate(latitude: 34.9859, longitude: 135.7585))

    @Test func fetchLocationsStoresAndReturnsTheList() async throws {
        let repository = LocationRepository(locationsService: FakeLocationsService(behavior: .success([amsterdam])))

        let locations = try await repository.fetchLocations()

        #expect(locations == [amsterdam])
    }

    @Test func fetchLocationsPropagatesFailure() async {
        let repository = LocationRepository(locationsService: FakeLocationsService(behavior: .failure(LocationsError.server)))

        await #expect(throws: LocationsError.server) {
            _ = try await repository.fetchLocations()
        }
    }

    @Test func addLocationAppendsToAnEmptyStore() async {
        let repository = LocationRepository(locationsService: FakeLocationsService(behavior: .success([])))

        let locations = await repository.addLocation(kyoto)

        #expect(locations == [kyoto])
    }

    @Test func addLocationAppendsAfterAFetch() async throws {
        let repository = LocationRepository(locationsService: FakeLocationsService(behavior: .success([amsterdam])))
        _ = try await repository.fetchLocations()

        let locations = await repository.addLocation(kyoto)

        #expect(locations == [amsterdam, kyoto])
    }

    @Test func multipleAddedLocationsAccumulate() async {
        let repository = LocationRepository(locationsService: FakeLocationsService(behavior: .success([])))

        _ = await repository.addLocation(amsterdam)
        let locations = await repository.addLocation(kyoto)

        #expect(locations == [amsterdam, kyoto])
    }
}
