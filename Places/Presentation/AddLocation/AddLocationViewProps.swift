//
//  AddLocationViewProps.swift
//  Places
//

/// Everything `AddLocationView` needs to render, resolved by
/// `AddLocationViewModel`. The view binds only to this single entity — it
/// never touches the view model's individual pieces of state or the
/// localization provider directly.
struct AddLocationViewProps: Equatable {
    var sheetTitle: String = ""
    var closeAccessibilityLabel: String = ""
    var nameFieldLabel: String = ""
    var nameFieldPlaceholder: String = ""
    var latitudeFieldLabel: String = ""
    var latitudeFieldPlaceholder: String = ""
    var longitudeFieldLabel: String = ""
    var longitudeFieldPlaceholder: String = ""
    var submitButtonTitle: String = ""

    var name: String = ""
    var latitudeText: String = ""
    var longitudeText: String = ""
    var validationErrorMessage: String?
    var validationErrorAccessibilityLabel: String?
    var createdLocation: Location?
}
