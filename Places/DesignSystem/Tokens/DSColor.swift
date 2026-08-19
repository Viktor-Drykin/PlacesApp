//
//  DSColor.swift
//  Places
//
//  Transcribed from the Claude Design mockup's tokens (styles.css).
//

import SwiftUI

enum DSColor {
    static let background = Color(hex: 0xF3F2F2)
    static let surface = Color(hex: 0xEAE9E9)
    static let text = Color(hex: 0x201F1D)

    /// Solid stand-ins for what used to be `text.opacity(...)` — precomputed
    /// blends of `text` over `background` so views never derive tints at
    /// the call site.
    static let textSecondary = Color(hex: 0x6E6D6C)
    static let textTertiary = Color(hex: 0x8C8B8A)
    static let divider = Color(hex: 0xD1D0D0)

    static let accent = Color(hex: 0xB68235)
    static let accent700 = Color(hex: 0x7D5411)
    static let accent800 = Color(hex: 0x5A3B0A)
    /// Pressed-state tint for accent-outlined buttons — the mockup's own
    /// `accent-200` ramp step, used instead of `accent.opacity(...)`.
    static let accentPressedBackground = Color(hex: 0xFFE3BF)

    /// Shadow color is inherently translucent; centralized here so views
    /// never write `.opacity(...)` themselves.
    static let shadowLarge = Color.black.opacity(DSShadow.lgOpacity)

    enum Neutral {
        static let n100 = Color(hex: 0xF8F4F4)
        static let n200 = Color(hex: 0xEAE7E7)
        static let n300 = Color(hex: 0xD7D3D3)
    }
}

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
