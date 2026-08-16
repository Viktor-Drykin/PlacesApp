//
//  PlacesCoordinator.swift
//  Places
//

import Observation

/// Orchestrates the two screens: what happens when the user wants to add a
/// location, and what happens once they submit one. Neither
/// `PlacesListView` nor `AddLocationView` know about each other — this is
/// the one place that does, so it's the only place cross-screen glue rules
/// like these live.
@Observable
@MainActor
final class PlacesCoordinator {
    enum Action: Sendable {
        case addLocationTapped
        case addLocationSubmitted
    }

    let placesListViewModel: PlacesListViewModel
    let addLocationViewModel: AddLocationViewModel
    var isAddSheetPresented = false

    init(placesListViewModel: PlacesListViewModel, addLocationViewModel: AddLocationViewModel) {
        self.placesListViewModel = placesListViewModel
        self.addLocationViewModel = addLocationViewModel
    }

    func performAction(_ action: Action) async {
        switch action {
        case .addLocationTapped:
            addLocationViewModel.performAction(.reset)
            isAddSheetPresented = true
        case .addLocationSubmitted:
            guard let entry = addLocationViewModel.props.submittedEntry else { return }
            await placesListViewModel.performAction(.addLocation(name: entry.name, latitude: entry.latitude, longitude: entry.longitude))
            isAddSheetPresented = false
        }
    }
}
