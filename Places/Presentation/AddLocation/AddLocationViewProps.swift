//
//  AddLocationViewProps.swift
//  Places
//

/// Everything `AddLocationView` needs to render, resolved by
/// `AddLocationViewModel`. The view binds only to this single entity — it
/// never touches the view model's individual pieces of state or the
/// localization provider directly.
///
/// A custom initializer (rather than the synthesized memberwise one) so the
/// optional fields don't silently default to `nil` — every caller passes
/// every value explicitly.
struct AddLocationViewProps: Equatable {
    /// This screen's own location model — not shared with `PlacesList`. No
    /// `id`: this is just validated form output, not yet an identified
    /// entry — minting an id for it is `PlacesListViewModel`'s job once it
    /// actually adds the location to the list.
    struct SubmittedLocation: Equatable {
        let name: String?
        let latitude: Double
        let longitude: Double
    }

    /// Which coordinate field a validation failure applies to, so the view
    /// can move focus there and surface the error on that specific field
    /// instead of only in a caption VoiceOver has no reason to visit.
    enum Field: Equatable {
        case latitude, longitude
    }

    var sheetTitle: String
    var closeAccessibilityLabel: String
    var nameFieldLabel: String
    var nameFieldPlaceholder: String
    var latitudeFieldLabel: String
    var latitudeFieldPlaceholder: String
    var longitudeFieldLabel: String
    var longitudeFieldPlaceholder: String
    var submitButtonTitle: String

    var name: String
    var latitudeText: String
    var longitudeText: String
    var validationErrorMessage: String?
    var validationErrorAccessibilityLabel: String?
    var invalidField: Field?
    var submittedEntry: SubmittedLocation?

    init(
        sheetTitle: String,
        closeAccessibilityLabel: String,
        nameFieldLabel: String,
        nameFieldPlaceholder: String,
        latitudeFieldLabel: String,
        latitudeFieldPlaceholder: String,
        longitudeFieldLabel: String,
        longitudeFieldPlaceholder: String,
        submitButtonTitle: String,
        name: String,
        latitudeText: String,
        longitudeText: String,
        validationErrorMessage: String?,
        validationErrorAccessibilityLabel: String?,
        invalidField: Field?,
        submittedEntry: SubmittedLocation?
    ) {
        self.sheetTitle = sheetTitle
        self.closeAccessibilityLabel = closeAccessibilityLabel
        self.nameFieldLabel = nameFieldLabel
        self.nameFieldPlaceholder = nameFieldPlaceholder
        self.latitudeFieldLabel = latitudeFieldLabel
        self.latitudeFieldPlaceholder = latitudeFieldPlaceholder
        self.longitudeFieldLabel = longitudeFieldLabel
        self.longitudeFieldPlaceholder = longitudeFieldPlaceholder
        self.submitButtonTitle = submitButtonTitle
        self.name = name
        self.latitudeText = latitudeText
        self.longitudeText = longitudeText
        self.validationErrorMessage = validationErrorMessage
        self.validationErrorAccessibilityLabel = validationErrorAccessibilityLabel
        self.invalidField = invalidField
        self.submittedEntry = submittedEntry
    }
}
