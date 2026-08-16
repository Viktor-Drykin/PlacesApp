//
//  AddLocationViewModelTests.swift
//  PlacesTests
//

import Testing
@testable import Places

@MainActor
struct AddLocationViewModelTests {
    private let localization = AddLocationLocalizationProvider()

    @Test func invalidLatitudeSetsValidationError() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.latitudeText = "200"
        sut.props.longitudeText = "10"

        sut.performAction(.submit)

        #expect(sut.props.validationErrorMessage == localization.message(for: .invalidLatitude))
        #expect(sut.props.createdLocation == nil)
    }

    @Test func invalidLongitudeSetsValidationError() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.latitudeText = "10"
        sut.props.longitudeText = "200"

        sut.performAction(.submit)

        #expect(sut.props.validationErrorMessage == localization.message(for: .invalidLongitude))
        #expect(sut.props.createdLocation == nil)
    }

    @Test func validSubmissionCreatesLocationWithGivenName() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.name = "Kyoto Station"
        sut.props.latitudeText = "34.9859"
        sut.props.longitudeText = "135.7585"

        sut.performAction(.submit)

        #expect(sut.props.validationErrorMessage == nil)
        #expect(sut.props.createdLocation?.name == "Kyoto Station")
        #expect(sut.props.createdLocation?.coordinate == Coordinate(latitude: 34.9859, longitude: 135.7585))
    }

    @Test func blankNameProducesNilName() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.latitudeText = "52.3676"
        sut.props.longitudeText = "4.9041"

        sut.performAction(.submit)

        #expect(sut.props.createdLocation?.name == nil)
    }

    @Test func resetClearsFieldsAndErrors() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.name = "Kyoto Station"
        sut.props.latitudeText = "200"
        sut.props.longitudeText = "10"
        sut.performAction(.submit)
        #expect(sut.props.validationErrorMessage != nil)

        sut.performAction(.reset)

        #expect(sut.props.name.isEmpty)
        #expect(sut.props.latitudeText.isEmpty)
        #expect(sut.props.longitudeText.isEmpty)
        #expect(sut.props.validationErrorMessage == nil)
        #expect(sut.props.createdLocation == nil)
    }
}
