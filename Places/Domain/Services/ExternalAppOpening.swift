//
//  ExternalAppOpening.swift
//  Places
//

import Foundation

/// Abstraction over `UIApplication`, so opening external URLs is testable
/// without touching UIKit in unit tests.
protocol ExternalAppOpener: Sendable {
    func canOpen(_ url: URL) async -> Bool
    @discardableResult
    func open(_ url: URL) async -> Bool
}
