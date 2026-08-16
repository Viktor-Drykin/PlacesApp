//
//  AppDependencies.swift
//  Places
//

import Foundation

/// Manual composition root: wires the concrete production implementations
/// together and hands out ready-to-use view models. Kept deliberately
/// framework-free (no DI container) since the object graph is small.
struct AppDependencies {
    let fetchLocationsUseCase: FetchLocationsUseCase
    let addLocationUseCase: AddLocationUseCase
    let wikipediaOpener: WikipediaOpener

    init() {
        let networkService = NetworkService(urlSession: .shared)
        let locationsService = LocationsService(networkService: networkService, decoder: JSONDecoder())
        // Single shared repository instance behind both use cases, so
        // fetched and user-added locations live in one consistent list.
        let repository = LocationRepository(locationsService: locationsService)
        self.fetchLocationsUseCase = DefaultFetchLocationsUseCase(repository: repository)
        self.addLocationUseCase = DefaultAddLocationUseCase(repository: repository)
        self.wikipediaOpener = WikipediaOpener(
            linkBuilder: WikipediaDeepLinkBuilder(),
            appOpener: UIKitExternalAppOpener()
        )
    }

    @MainActor
    func makePlacesListViewModel() -> PlacesListViewModel {
        PlacesListViewModel(
            fetchLocationsUseCase: fetchLocationsUseCase,
            addLocationUseCase: addLocationUseCase,
            wikipediaOpener: wikipediaOpener,
            localization: PlacesListLocalizationProvider()
        )
    }

    @MainActor
    func makeAddLocationViewModel() -> AddLocationViewModel {
        AddLocationViewModel(localization: AddLocationLocalizationProvider())
    }
}
