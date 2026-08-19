//
//  AddLocationViewModel.swift
//  Places
//

import Foundation
import Observation

@Observable
@MainActor
final class AddLocationViewModel {
    struct SubmittedLocation: Equatable, Sendable {
        let name: String?
        let latitude: Double
        let longitude: Double
    }

    enum Action: Sendable {
        case reset
        case submit
    }

    /// Not `private(set)`: text fields bind into this directly via
    /// `$viewModel.props.name` etc. — continuous input isn't routed through
    /// `performAction`, only discrete commands are.
    var props: AddLocationViewProps

    var onSubmit: (SubmittedLocation) -> Void = { _ in }

    private let localization: AddLocationLocalizationProvider

    init(localization: AddLocationLocalizationProvider) {
        self.localization = localization
        self.props = AddLocationViewProps(
            sheetTitle: localization.sheetTitle,
            closeAccessibilityLabel: localization.closeAccessibilityLabel,
            nameFieldLabel: localization.nameFieldLabel,
            nameFieldPlaceholder: localization.nameFieldPlaceholder,
            latitudeFieldLabel: localization.latitudeFieldLabel,
            latitudeFieldPlaceholder: localization.latitudeFieldPlaceholder,
            longitudeFieldLabel: localization.longitudeFieldLabel,
            longitudeFieldPlaceholder: localization.longitudeFieldPlaceholder,
            submitButtonTitle: localization.submitButtonTitle,
            name: "",
            latitudeText: "",
            longitudeText: "",
            validationErrorMessage: nil,
            validationErrorAccessibilityLabel: nil,
            invalidField: nil
        )
    }

    /// Single entry point for every user-initiated event from the view.
    /// Text field edits are plain two-way bindings into `props` rather than
    /// actions, since they're continuous input, not discrete commands.
    func performAction(_ action: Action) {
        switch action {
        case .reset:
            reset()
        case .submit:
            submit()
        }
    }

    private func reset() {
        props.name = ""
        props.latitudeText = ""
        props.longitudeText = ""
        props.validationErrorMessage = nil
        props.validationErrorAccessibilityLabel = nil
        props.invalidField = nil
    }

    private func submit() {
        props.validationErrorMessage = nil
        props.validationErrorAccessibilityLabel = nil
        props.invalidField = nil

        let latitudeResult = ValidateCoordinateUseCase.validateLatitude(props.latitudeText)
        guard case .success(let latitude) = latitudeResult else {
            if case .failure(let error) = latitudeResult { setValidationError(localization.message(for: error), field: .latitude) }
            return
        }

        let longitudeResult = ValidateCoordinateUseCase.validateLongitude(props.longitudeText)
        guard case .success(let longitude) = longitudeResult else {
            if case .failure(let error) = longitudeResult { setValidationError(localization.message(for: error), field: .longitude) }
            return
        }

        let trimmedName = props.name.trimmingCharacters(in: .whitespacesAndNewlines)
        onSubmit(SubmittedLocation(
            name: trimmedName.isEmpty ? nil : trimmedName,
            latitude: latitude,
            longitude: longitude
        ))
    }

    private func setValidationError(_ message: String, field: AddLocationViewProps.Field) {
        props.validationErrorMessage = message
        props.validationErrorAccessibilityLabel = localization.validationErrorAccessibilityLabel(for: message)
        props.invalidField = field
    }
}
