//
//  WikipediaOpener.swift
//  Places
//

/// Shared "open this coordinate in the Wikipedia app" flow, used by both the
/// locations list and the add-custom-location form so the logic lives in one
/// place.
struct WikipediaOpener: Sendable {
    let linkBuilder: WikipediaLinkBuilder
    let appOpener: ExternalAppOpener

    /// Returns `true` if the Wikipedia app was opened, `false` if it isn't installed.
    @discardableResult
    func open(_ coordinate: Coordinate) async -> Bool {
        guard let url = linkBuilder.url(for: coordinate) else { return false }
        guard await appOpener.canOpen(url) else { return false }
        return await appOpener.open(url)
    }
}
