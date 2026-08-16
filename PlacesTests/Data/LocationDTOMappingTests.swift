//
//  LocationDTOMappingTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

struct LocationDTOMappingTests {
    @Test func mapsNameWhenPresent() {
        let dto = LocationDTO(name: "Amsterdam", lat: 52.3547498, long: 4.8339215)
        let location = dto.toDomain()
        #expect(location.name == "Amsterdam")
        #expect(location.coordinate == Coordinate(latitude: 52.3547498, longitude: 4.8339215))
    }

    @Test func nameIsNilWhenMissing() {
        let dto = LocationDTO(name: nil, lat: 40.4380638, long: -3.7495758)
        let location = dto.toDomain()
        #expect(location.name == nil)
    }

    @Test func nameIsNilWhenBlank() {
        let dto = LocationDTO(name: "   ", lat: 1, long: 1)
        let location = dto.toDomain()
        #expect(location.name == nil)
    }

    @Test func decodesResponseFromJSON() throws {
        let json = """
        { "locations": [
            { "name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215 },
            { "lat": 40.4380638, "long": -3.7495758 }
        ] }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(LocationsResponseDTO.self, from: json)
        #expect(response.locations.count == 2)
        #expect(response.locations[0].name == "Amsterdam")
        #expect(response.locations[1].name == nil)
    }
}
