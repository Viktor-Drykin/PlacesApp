//
//  PlacesListLocalization.swift
//  Places
//
import Foundation

/// Owns every user-facing string for the Places list screen, including how
/// domain errors are worded. Consumed by `PlacesListViewModel` only — views
/// never reference this type directly.
struct PlacesListLocalizationProvider {
    var title: String {
        String(localized: "places_list.title", defaultValue: "Places")
    }

    func subtitle(count: Int) -> String {
        if count == 1 {
            return String(localized: "places_list.subtitle.one", defaultValue: "1 saved location")
        }
        return String(localized: "places_list.subtitle.many", defaultValue: "\(count) saved locations")
    }

    /// Placeholder subtitle shown while the list isn't in its loaded state
    /// (keeps the header's height stable instead of collapsing).
    var subtitlePlaceholder: String {
        " "
    }

    func formattedCoordinate(_ coordinate: Coordinate) -> String {
        CoordinateFormatting.format(coordinate)
    }

    var addLocationAccessibilityLabel: String {
        String(localized: "places_list.add_location.accessibility_label", defaultValue: "Add a location")
    }

    var wikipediaAppMissingAlertTitle: String {
        String(localized: "places_list.wikipedia_missing_alert.title", defaultValue: "Wikipedia app isn't installed")
    }

    var alertOKButtonTitle: String {
        String(localized: "places_list.alert.ok_button", defaultValue: "OK")
    }

    var errorStateTitle: String {
        String(localized: "places_list.error_state.title", defaultValue: "Couldn't load locations")
    }

    var retryButtonTitle: String {
        String(localized: "places_list.error_state.retry_button", defaultValue: "Retry")
    }

    var emptyStateTitle: String {
        String(localized: "places_list.empty_state.title", defaultValue: "No places yet")
    }

    var emptyStateMessage: String {
        String(localized: "places_list.empty_state.message", defaultValue: "Add a location to start your list.")
    }

    var loadingAccessibilityLabel: String {
        String(localized: "places_list.loading.accessibility_label", defaultValue: "Loading locations")
    }

    var placeRowAccessibilityHint: String {
        String(localized: "places_list.place_row.accessibility_hint", defaultValue: "Opens this location in the Wikipedia app")
    }

    var unknownErrorMessage: String {
        String(localized: "places_list.error.unknown", defaultValue: "Something went wrong.")
    }

    func message(for error: LocationsError) -> String {
        switch error {
        case .network:
            return String(localized: "places_list.error.network", defaultValue: "Check your connection and try again.")
        case .decoding:
            return String(localized: "places_list.error.decoding", defaultValue: "The locations data couldn't be read.")
        case .invalidEndpoint, .unknown:
            return unknownErrorMessage
        }
    }
}
