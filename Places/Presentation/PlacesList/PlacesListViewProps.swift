//
//  PlacesListViewProps.swift
//  Places
//

/// Everything `PlacesListView` needs to render, resolved by
/// `PlacesListViewModel`. The view binds only to this single entity — it
/// never touches the view model's individual pieces of state or the
/// localization provider directly.
struct PlacesListViewProps: Equatable {
    /// This screen's own location model — not shared with `AddLocation`,
    /// even though the shape is similar; each screen owns its data model.
    struct Location: Equatable, Sendable {
        let id: String
        let name: String?
        let latitude: Double
        let longitude: Double
    }

    struct PlaceRowProps: Identifiable, Equatable, Sendable {
        let location: Location
        let displayName: String
        let coordinatesText: String

        var id: String { location.id }
    }

    enum LoadState: Equatable {
        case loading
        case error(message: String)
        case empty
        case loaded([PlaceRowProps])
    }

    var title: String
    var subtitle: String
    var loadState: LoadState
    var addLocationAccessibilityLabel: String
    var loadingAccessibilityLabel: String
    var placeRowAccessibilityHint: String
    var errorStateTitle: String
    var retryButtonTitle: String
    var emptyStateTitle: String
    var emptyStateMessage: String
    var wikipediaAppMissingAlertTitle: String
    var alertOKButtonTitle: String
    var isWikipediaAppMissingAlertPresented: Bool
}
