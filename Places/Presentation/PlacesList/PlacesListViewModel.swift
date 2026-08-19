//
//  PlacesListViewModel.swift
//  Places
//

import Foundation
import Observation

@Observable
@MainActor
final class PlacesListViewModel {
    enum Action: Sendable {
        case onAppear
        case retry
        case selectLocation(PlacesListViewProps.Location)
        case addLocation(name: String?, latitude: Double, longitude: Double)
    }

    /// Not `private(set)`: the Wikipedia-missing alert binds
    /// `isWikipediaAppMissingAlertPresented` directly via
    /// `$viewModel.props.isWikipediaAppMissingAlertPresented`.
    var props: PlacesListViewProps

    private let fetchLocationsUseCase: FetchLocationsUseCase
    private let addLocationUseCase: AddLocationUseCase
    private let wikipediaOpener: WikipediaOpener
    private let localization: PlacesListLocalizationProvider

    init(
        fetchLocationsUseCase: FetchLocationsUseCase,
        addLocationUseCase: AddLocationUseCase,
        wikipediaOpener: WikipediaOpener,
        localization: PlacesListLocalizationProvider
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.addLocationUseCase = addLocationUseCase
        self.wikipediaOpener = wikipediaOpener
        self.localization = localization
        self.props = PlacesListViewProps(
            title: localization.title,
            subtitle: localization.subtitlePlaceholder,
            loadState: .loading,
            addLocationAccessibilityLabel: localization.addLocationAccessibilityLabel,
            loadingAccessibilityLabel: localization.loadingAccessibilityLabel,
            placeRowAccessibilityHint: localization.placeRowAccessibilityHint,
            errorStateTitle: localization.errorStateTitle,
            retryButtonTitle: localization.retryButtonTitle,
            emptyStateTitle: localization.emptyStateTitle,
            emptyStateMessage: localization.emptyStateMessage,
            wikipediaAppMissingAlertTitle: localization.wikipediaAppMissingAlertTitle,
            wikipediaAppMissingAlertMessage: localization.wikipediaAppMissingAlertMessage,
            alertOKButtonTitle: localization.alertOKButtonTitle,
            isWikipediaAppMissingAlertPresented: false
        )
    }

    /// Single entry point for every user-initiated event from the view.
    func performAction(_ action: Action) async {
        switch action {
        case .onAppear, .retry:
            await load()
        case .selectLocation(let location):
            await selectLocation(location)
        case .addLocation(let name, let latitude, let longitude):
            await addLocation(name: name, latitude: latitude, longitude: longitude)
        }
    }

    private func load() async {
        props.loadState = .loading
        props.subtitle = localization.subtitlePlaceholder
        do {
            let locations = try await fetchLocationsUseCase.execute()
            applyLocations(locations)
        } catch let error as LocationsError {
            props.loadState = .error(message: localization.message(for: error))
        } catch {
            props.loadState = .error(message: localization.unknownErrorMessage)
        }
    }

    private func selectLocation(_ location: PlacesListViewProps.Location) async {
        let coordinate = Coordinate(latitude: location.latitude, longitude: location.longitude)
        let opened = await wikipediaOpener.open(coordinate)
        if !opened {
            props.isWikipediaAppMissingAlertPresented = true
        }
    }

    private func addLocation(name: String?, latitude: Double, longitude: Double) async {
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)
        let location = Location(id: UUID().uuidString, name: name, coordinate: coordinate)
        let locations = await addLocationUseCase.execute(location)
        applyLocations(locations)
    }

    private func applyLocations(_ locations: [Location]) {
        guard !locations.isEmpty else {
            props.loadState = .empty
            props.subtitle = localization.subtitlePlaceholder
            return
        }

        let rows = locations.map { location in
            PlacesListViewProps.PlaceRowProps(
                location: PlacesListViewProps.Location(
                    id: location.id,
                    name: location.name,
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                ),
                displayName: location.name ?? localization.formattedCoordinate(location.coordinate),
                coordinatesText: localization.formattedCoordinate(location.coordinate)
            )
        }
        props.loadState = .loaded(rows)
        props.subtitle = localization.subtitle(count: locations.count)
    }
}
