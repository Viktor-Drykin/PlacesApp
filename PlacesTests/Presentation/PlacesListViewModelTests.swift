//
//  PlacesListViewModelTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

/// Mirrors production wiring: both use cases in the SUT wrap this single
/// fake repository, so tests exercise the same shared-state behavior as
/// `LocationRepository` does in the app.
private final class FakeLocationsRepository: LocationsRepositoryProtocol, @unchecked Sendable {
    enum FetchBehavior {
        case success([Location])
        case failure(Error)
    }

    private let fetchBehavior: FetchBehavior
    private(set) var storedLocations: [Location] = []

    init(fetchBehavior: FetchBehavior) {
        self.fetchBehavior = fetchBehavior
    }

    func fetchLocations() async throws -> [Location] {
        switch fetchBehavior {
        case .success(let locations):
            storedLocations = locations
            return storedLocations
        case .failure(let error):
            throw error
        }
    }

    func addLocation(_ location: Location) async -> [Location] {
        storedLocations.append(location)
        return storedLocations
    }
}

private final class FakeExternalAppOpener: ExternalAppOpener, @unchecked Sendable {
    var canOpenResult = true
    var openResult = true
    private(set) var openedURLs: [URL] = []

    func canOpen(_ url: URL) async -> Bool { canOpenResult }

    func open(_ url: URL) async -> Bool {
        openedURLs.append(url)
        return openResult
    }
}

private extension Location {
    var asPlacesListLocation: PlacesListViewProps.Location {
        PlacesListViewProps.Location(id: id, name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

@MainActor
struct PlacesListViewModelTests {
    private let amsterdam = Location(id: UUID().uuidString, name: "Amsterdam", coordinate: Coordinate(latitude: 52.3547498, longitude: 4.8339215))
    private let kyoto = Location(id: UUID().uuidString, name: "Kyoto Station", coordinate: Coordinate(latitude: 34.9859, longitude: 135.7585))

    private func makeSUT(
        fetchBehavior: FakeLocationsRepository.FetchBehavior,
        appOpener: FakeExternalAppOpener
    ) -> PlacesListViewModel {
        let repository = FakeLocationsRepository(fetchBehavior: fetchBehavior)
        let opener = WikipediaOpener(linkBuilder: WikipediaDeepLinkBuilder(), appOpener: appOpener)
        return PlacesListViewModel(
            fetchLocationsUseCase: DefaultFetchLocationsUseCase(repository: repository),
            addLocationUseCase: DefaultAddLocationUseCase(repository: repository),
            wikipediaOpener: opener,
            localization: PlacesListLocalizationProvider()
        )
    }

    @Test func onAppearTransitionsToLoadedOnSuccess() async {
        let sut = makeSUT(fetchBehavior: .success([amsterdam]), appOpener: FakeExternalAppOpener())
        await sut.performAction(.onAppear)

        guard case .loaded(let rows) = sut.props.loadState else {
            Issue.record("Expected .loaded, got \(sut.props.loadState)")
            return
        }
        #expect(rows.map(\.id) == [amsterdam.id])
        #expect(rows.first?.displayName == "Amsterdam")
    }

    @Test func onAppearTransitionsToEmptyWhenNoLocations() async {
        let sut = makeSUT(fetchBehavior: .success([]), appOpener: FakeExternalAppOpener())
        await sut.performAction(.onAppear)
        #expect(sut.props.loadState == .empty)
    }

    @Test func onAppearTransitionsToErrorOnFailure() async {
        let sut = makeSUT(fetchBehavior: .failure(LocationsError.network), appOpener: FakeExternalAppOpener())
        await sut.performAction(.onAppear)

        guard case .error = sut.props.loadState else {
            Issue.record("Expected .error state, got \(sut.props.loadState)")
            return
        }
    }

    @Test func selectLocationOpensWikipediaWithExpectedURL() async {
        let opener = FakeExternalAppOpener()
        let sut = makeSUT(fetchBehavior: .success([amsterdam]), appOpener: opener)

        await sut.performAction(.selectLocation(amsterdam.asPlacesListLocation))

        #expect(opener.openedURLs.count == 1)
        #expect(opener.openedURLs.first?.scheme == "wikipedia")
        #expect(sut.props.isWikipediaAppMissingAlertPresented == false)
    }

    @Test func selectLocationFlagsMissingAppWhenItCannotBeOpened() async {
        let opener = FakeExternalAppOpener()
        opener.canOpenResult = false
        let sut = makeSUT(fetchBehavior: .success([amsterdam]), appOpener: opener)

        await sut.performAction(.selectLocation(amsterdam.asPlacesListLocation))

        #expect(opener.openedURLs.isEmpty)
        #expect(sut.props.isWikipediaAppMissingAlertPresented == true)
    }

    @Test func addLocationAppendsToLoadedList() async {
        let sut = makeSUT(fetchBehavior: .success([amsterdam]), appOpener: FakeExternalAppOpener())
        await sut.performAction(.onAppear)

        await sut.performAction(.addLocation(name: kyoto.name, latitude: kyoto.coordinate.latitude, longitude: kyoto.coordinate.longitude))

        guard case .loaded(let rows) = sut.props.loadState else {
            Issue.record("Expected .loaded, got \(sut.props.loadState)")
            return
        }
        #expect(rows.map(\.displayName) == ["Amsterdam", "Kyoto Station"])
    }

    @Test func addLocationReplacesEmptyState() async {
        let sut = makeSUT(fetchBehavior: .success([]), appOpener: FakeExternalAppOpener())
        await sut.performAction(.onAppear)
        #expect(sut.props.loadState == .empty)

        await sut.performAction(.addLocation(name: kyoto.name, latitude: kyoto.coordinate.latitude, longitude: kyoto.coordinate.longitude))

        guard case .loaded(let rows) = sut.props.loadState else {
            Issue.record("Expected .loaded, got \(sut.props.loadState)")
            return
        }
        #expect(rows.map(\.displayName) == ["Kyoto Station"])
    }

    @Test func addLocationBeforeAnyFetchStillAccumulates() async {
        let sut = makeSUT(fetchBehavior: .success([amsterdam]), appOpener: FakeExternalAppOpener())

        await sut.performAction(.addLocation(name: kyoto.name, latitude: kyoto.coordinate.latitude, longitude: kyoto.coordinate.longitude))

        guard case .loaded(let rows) = sut.props.loadState else {
            Issue.record("Expected .loaded, got \(sut.props.loadState)")
            return
        }
        #expect(rows.map(\.displayName) == ["Kyoto Station"])
    }
}
