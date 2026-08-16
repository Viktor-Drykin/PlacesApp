//
//  ValidateCoordinateUseCaseTests.swift
//  PlacesTests
//

import Testing
@testable import Places

struct ValidateCoordinateUseCaseTests {
    @Test func validLatitude() {
        #expect(ValidateCoordinateUseCase.validateLatitude("52.3676") == .success(52.3676))
    }

    @Test func latitudeBoundariesAreValid() {
        #expect(ValidateCoordinateUseCase.validateLatitude("90") == .success(90))
        #expect(ValidateCoordinateUseCase.validateLatitude("-90") == .success(-90))
    }

    @Test func latitudeOutOfRangeFails() {
        #expect(ValidateCoordinateUseCase.validateLatitude("90.1") == .failure(.invalidLatitude))
        #expect(ValidateCoordinateUseCase.validateLatitude("-90.1") == .failure(.invalidLatitude))
    }

    @Test func nonNumericLatitudeFails() {
        #expect(ValidateCoordinateUseCase.validateLatitude("abc") == .failure(.invalidLatitude))
        #expect(ValidateCoordinateUseCase.validateLatitude("") == .failure(.invalidLatitude))
    }

    @Test func validLongitude() {
        #expect(ValidateCoordinateUseCase.validateLongitude("4.9041") == .success(4.9041))
    }

    @Test func longitudeBoundariesAreValid() {
        #expect(ValidateCoordinateUseCase.validateLongitude("180") == .success(180))
        #expect(ValidateCoordinateUseCase.validateLongitude("-180") == .success(-180))
    }

    @Test func longitudeOutOfRangeFails() {
        #expect(ValidateCoordinateUseCase.validateLongitude("180.1") == .failure(.invalidLongitude))
        #expect(ValidateCoordinateUseCase.validateLongitude("-180.1") == .failure(.invalidLongitude))
    }

    @Test func nonNumericLongitudeFails() {
        #expect(ValidateCoordinateUseCase.validateLongitude("xyz") == .failure(.invalidLongitude))
    }
}
