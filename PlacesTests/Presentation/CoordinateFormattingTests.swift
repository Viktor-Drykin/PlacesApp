//
//  CoordinateFormattingTests.swift
//  PlacesTests
//

import Testing
@testable import Places

struct CoordinateFormattingTests {
    @Test func formatsNorthEast() {
        let coordinate = Coordinate(latitude: 52.3547498, longitude: 4.8339215)
        #expect(CoordinateFormatting.format(coordinate) == "52.3547° N, 4.8339° E")
    }

    @Test func formatsSouthWest() {
        let coordinate = Coordinate(latitude: -13.1631, longitude: -72.5450)
        #expect(CoordinateFormatting.format(coordinate) == "13.1631° S, 72.5450° W")
    }

    @Test func formatsZeroAsNorthEast() {
        let coordinate = Coordinate(latitude: 0, longitude: 0)
        #expect(CoordinateFormatting.format(coordinate) == "0.0000° N, 0.0000° E")
    }
}
