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
        #expect(sut.props.invalidField == .latitude)
        #expect(sut.props.submittedEntry == nil)
    }

    @Test func invalidLongitudeSetsValidationError() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.latitudeText = "10"
        sut.props.longitudeText = "200"

        sut.performAction(.submit)

        #expect(sut.props.validationErrorMessage == localization.message(for: .invalidLongitude))
        #expect(sut.props.invalidField == .longitude)
        #expect(sut.props.submittedEntry == nil)
    }

    @Test func validSubmissionCreatesLocationWithGivenName() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.name = "Kyoto Station"
        sut.props.latitudeText = "34.9859"
        sut.props.longitudeText = "135.7585"

        sut.performAction(.submit)

        #expect(sut.props.validationErrorMessage == nil)
        #expect(sut.props.submittedEntry?.name == "Kyoto Station")
        #expect(sut.props.submittedEntry?.latitude == 34.9859)
        #expect(sut.props.submittedEntry?.longitude == 135.7585)
    }

    @Test func blankNameProducesNilName() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.latitudeText = "52.3676"
        sut.props.longitudeText = "4.9041"

        sut.performAction(.submit)

        #expect(sut.props.submittedEntry?.name == nil)
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
        #expect(sut.props.submittedEntry == nil)
    }
}
