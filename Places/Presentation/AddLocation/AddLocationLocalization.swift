//
//  AddLocationLocalization.swift
//  Places
//
import Foundation

/// Owns every user-facing string for the Add Location sheet, including how
/// validation errors are worded. Consumed by `AddLocationViewModel` only —
/// views never reference this type directly.
struct AddLocationLocalizationProvider {
    var sheetTitle: String {
        String(localized: "add_location.sheet_title", defaultValue: "Add a location")
    }

    var closeAccessibilityLabel: String {
        String(localized: "add_location.close.accessibility_label", defaultValue: "Close")
    }

    var nameFieldLabel: String {
        String(localized: "add_location.name_field.label", defaultValue: "Name")
    }

    var nameFieldPlaceholder: String {
        String(localized: "add_location.name_field.placeholder", defaultValue: "e.g. Kyoto Station")
    }

    var latitudeFieldLabel: String {
        String(localized: "add_location.latitude_field.label", defaultValue: "Latitude")
    }

    var latitudeFieldPlaceholder: String {
        String(localized: "add_location.latitude_field.placeholder", defaultValue: "34.9859")
    }

    var longitudeFieldLabel: String {
        String(localized: "add_location.longitude_field.label", defaultValue: "Longitude")
    }

    var longitudeFieldPlaceholder: String {
        String(localized: "add_location.longitude_field.placeholder", defaultValue: "135.7585")
    }

    var submitButtonTitle: String {
        String(localized: "add_location.submit_button", defaultValue: "Add Location")
    }

    func validationErrorAccessibilityLabel(for message: String) -> String {
        String(localized: "add_location.validation_error.accessibility_label", defaultValue: "Error: \(message)")
    }

    func message(for error: CoordinateValidationError) -> String {
        switch error {
        case .invalidLatitude:
            return String(localized: "add_location.error.invalid_latitude", defaultValue: "Enter a valid latitude between -90 and 90.")
        case .invalidLongitude:
            return String(localized: "add_location.error.invalid_longitude", defaultValue: "Enter a valid longitude between -180 and 180.")
        }
    }

    func formattedCoordinate(_ coordinate: Coordinate) -> String {
        CoordinateFormatting.format(coordinate)
    }
}
