//
//  PrimaryButton.swift
//  Places
//

import SwiftUI

/// Accent-outlined button matching the mockup's `.btn-primary` style.
struct PrimaryButtonStyle: ButtonStyle {
    var isBlock: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontDesign(.serif)
            .foregroundStyle(DSColor.accent)
            .padding(.vertical, DSSpacing.space2)
            .padding(.horizontal, DSSpacing.space4)
            .frame(maxWidth: isBlock ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: DSRadius.md)
                    .fill(configuration.isPressed ? DSColor.accentPressedBackground : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md)
                    .strokeBorder(DSColor.accent, lineWidth: 1)
            )
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var dsPrimary: PrimaryButtonStyle { PrimaryButtonStyle() }
    static var dsPrimaryBlock: PrimaryButtonStyle { PrimaryButtonStyle(isBlock: true) }
}
