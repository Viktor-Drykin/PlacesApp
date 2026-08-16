//
//  PlacesCoordinatorTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

private final class FakeLocationsRepository: LocationsRepositoryProtocol, @unchecked Sendable {
    private(set) var storedLocations: [Location] = []

    func fetchLocations() async throws -> [Location] { storedLocations }

    func addLocation(_ location: Location) async -> [Location] {
        storedLocations.append(location)
        return storedLocations
    }
}

private final class FakeExternalAppOpener: ExternalAppOpener, @unchecked Sendable {
    func canOpen(_ url: URL) async -> Bool { true }
    func open(_ url: URL) async -> Bool { true }
}

@MainActor
struct PlacesCoordinatorTests {
    private func makeSUT() -> PlacesCoordinator {
        let repository = FakeLocationsRepository()
        let placesListViewModel = PlacesListViewModel(
            fetchLocationsUseCase: DefaultFetchLocationsUseCase(repository: repository),
            addLocationUseCase: DefaultAddLocationUseCase(repository: repository),
            wikipediaOpener: WikipediaOpener(linkBuilder: WikipediaDeepLinkBuilder(), appOpener: FakeExternalAppOpener()),
            localization: PlacesListLocalizationProvider()
        )
        let addLocationViewModel = AddLocationViewModel(localization: AddLocationLocalizationProvider())
        return PlacesCoordinator(placesListViewModel: placesListViewModel, addLocationViewModel: addLocationViewModel)
    }

    @Test func addLocationTappedResetsFormAndOpensSheet() async {
        let sut = makeSUT()
        sut.addLocationViewModel.props.name = "leftover text"
        sut.addLocationViewModel.props.validationErrorMessage = "leftover error"

        await sut.performAction(.addLocationTapped)

        #expect(sut.isAddSheetPresented == true)
        #expect(sut.addLocationViewModel.props.name.isEmpty)
        #expect(sut.addLocationViewModel.props.validationErrorMessage == nil)
    }

    @Test func addLocationSubmittedForwardsEntryAndClosesSheet() async {
        let sut = makeSUT()
        sut.isAddSheetPresented = true
        sut.addLocationViewModel.props.name = "Kyoto Station"
        sut.addLocationViewModel.props.latitudeText = "34.9859"
        sut.addLocationViewModel.props.longitudeText = "135.7585"
        sut.addLocationViewModel.performAction(.submit)

        await sut.performAction(.addLocationSubmitted)

        #expect(sut.isAddSheetPresented == false)
        guard case .loaded(let rows) = sut.placesListViewModel.props.loadState else {
            Issue.record("Expected .loaded, got \(sut.placesListViewModel.props.loadState)")
            return
        }
        #expect(rows.map(\.displayName) == ["Kyoto Station"])
    }

    @Test func addLocationSubmittedWithoutAValidatedEntryDoesNothing() async {
        let sut = makeSUT()
        sut.isAddSheetPresented = true

        await sut.performAction(.addLocationSubmitted)

        #expect(sut.isAddSheetPresented == true)
        #expect(sut.placesListViewModel.props.loadState == .loading)
    }
}
