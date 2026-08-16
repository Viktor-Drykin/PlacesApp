//
//  UIKitExternalAppOpener.swift
//  Places
//

import UIKit

/// Production `ExternalAppOpener` backed by `UIApplication`.
struct UIKitExternalAppOpener: ExternalAppOpener {
    func canOpen(_ url: URL) async -> Bool {
        await MainActor.run {
            UIApplication.shared.canOpenURL(url)
        }
    }

    @discardableResult
    func open(_ url: URL) async -> Bool {
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                UIApplication.shared.open(url, options: [:]) { success in
                    continuation.resume(returning: success)
                }
            }
        }
    }
}
