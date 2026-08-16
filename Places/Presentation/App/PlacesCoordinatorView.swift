//
//  PlacesCoordinatorView.swift
//  Places
//

import SwiftUI

/// Thin renderer over `PlacesCoordinator` — owns no logic of its own, just
/// the SwiftUI presentation (`sheet`/`onChange`) a plain object can't do.
struct PlacesCoordinatorView: View {
    @State private var coordinator: PlacesCoordinator

    init(dependencies: AppDependencies) {
        _coordinator = State(initialValue: PlacesCoordinator(
            placesListViewModel: dependencies.makePlacesListViewModel(),
            addLocationViewModel: dependencies.makeAddLocationViewModel()
        ))
    }

    var body: some View {
        PlacesListView(viewModel: coordinator.placesListViewModel) {
            Task { await coordinator.performAction(.addLocationTapped) }
        }
        .sheet(isPresented: $coordinator.isAddSheetPresented) {
            AddLocationView(viewModel: coordinator.addLocationViewModel, isPresented: $coordinator.isAddSheetPresented)
        }
        .onChange(of: coordinator.addLocationViewModel.props.submittedEntry) { _, _ in
            Task { await coordinator.performAction(.addLocationSubmitted) }
        }
    }
}

#Preview {
    PlacesCoordinatorView(dependencies: AppDependencies())
}
