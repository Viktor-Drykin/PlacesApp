//
//  CircularIconButton.swift
//  Places
//

import SwiftUI

/// Small circular outlined icon button, used for the floating add button and
/// the sheet's close button.
struct CircularIconButton: View {
    let systemImage: String
    let accessibilityLabel: String
    let action: () -> Void

    @ScaledMetric private var diameter: CGFloat

    /// Hit area is clamped to at least the 44pt minimum tap target, even
    /// when the visual diameter (e.g. the sheet's 32pt close button) is
    /// smaller.
    private var minTapTarget: CGFloat { 44 }

    init(systemImage: String, accessibilityLabel: String, diameter: CGFloat, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel
        self.action = action
        _diameter = ScaledMetric(wrappedValue: diameter)
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: diameter * 0.4, weight: .medium))
                .foregroundStyle(DSColor.accent700)
                .frame(width: diameter, height: diameter)
                .background(
                    Circle()
                        .fill(DSColor.background)
                        .overlay(Circle().strokeBorder(DSColor.accent, lineWidth: 1.5))
                )
                .frame(minWidth: minTapTarget, minHeight: minTapTarget)
                .contentShape(Rectangle())
        }
        .accessibilityLabel(accessibilityLabel)
    }
}
