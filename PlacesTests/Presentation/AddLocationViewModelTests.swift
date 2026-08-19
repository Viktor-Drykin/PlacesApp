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
        var submitted = false
        sut.onSubmit = { _ in submitted = true }

        sut.performAction(.submit)

        #expect(sut.props.validationErrorMessage == localization.message(for: .invalidLatitude))
        #expect(sut.props.invalidField == .latitude)
        #expect(!submitted)
    }

    @Test func invalidLongitudeSetsValidationError() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.latitudeText = "10"
        sut.props.longitudeText = "200"
        var submitted = false
        sut.onSubmit = { _ in submitted = true }

        sut.performAction(.submit)

        #expect(sut.props.validationErrorMessage == localization.message(for: .invalidLongitude))
        #expect(sut.props.invalidField == .longitude)
        #expect(!submitted)
    }

    @Test func validSubmissionCreatesLocationWithGivenName() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.name = "Kyoto Station"
        sut.props.latitudeText = "34.9859"
        sut.props.longitudeText = "135.7585"
        var captured: AddLocationViewModel.SubmittedLocation?
        sut.onSubmit = { captured = $0 }

        sut.performAction(.submit)

        #expect(sut.props.validationErrorMessage == nil)
        #expect(captured?.name == "Kyoto Station")
        #expect(captured?.latitude == 34.9859)
        #expect(captured?.longitude == 135.7585)
    }

    @Test func blankNameProducesNilName() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.latitudeText = "52.3676"
        sut.props.longitudeText = "4.9041"
        var captured: AddLocationViewModel.SubmittedLocation?
        sut.onSubmit = { captured = $0 }

        sut.performAction(.submit)

        #expect(captured?.name == nil)
    }

    @Test func resetClearsFieldsAndErrors() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.name = "Kyoto Station"
        sut.props.latitudeText = "200"
        sut.props.longitudeText = "10"
        var submitted = false
        sut.onSubmit = { _ in submitted = true }
        sut.performAction(.submit)
        #expect(sut.props.validationErrorMessage != nil)

        sut.performAction(.reset)

        #expect(sut.props.name.isEmpty)
        #expect(sut.props.latitudeText.isEmpty)
        #expect(sut.props.longitudeText.isEmpty)
        #expect(sut.props.validationErrorMessage == nil)
        #expect(!submitted)
    }

    @Test func resetAfterSuccessfulSubmitDoesNotRefireCallback() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.name = "Kyoto Station"
        sut.props.latitudeText = "34.9859"
        sut.props.longitudeText = "135.7585"
        var submitCount = 0
        sut.onSubmit = { _ in submitCount += 1 }
        sut.performAction(.submit)
        #expect(submitCount == 1)

        sut.performAction(.reset)

        #expect(submitCount == 1)
    }

    @Test func submitWithoutOnSubmitAssignedDoesNotCrash() {
        let sut = AddLocationViewModel(localization: localization)
        sut.props.name = "Kyoto Station"
        sut.props.latitudeText = "34.9859"
        sut.props.longitudeText = "135.7585"

        sut.performAction(.submit)
    }
}
