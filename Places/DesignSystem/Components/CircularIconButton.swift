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
    let diameter: CGFloat
    let action: () -> Void

    init(systemImage: String, accessibilityLabel: String, diameter: CGFloat = 32, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel
        self.diameter = diameter
        self.action = action
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
        }
        .accessibilityLabel(accessibilityLabel)
    }
}
