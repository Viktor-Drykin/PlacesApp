//
//  DSTextField.swift
//  Places
//

import SwiftUI

/// Labeled text field matching the mockup's `.field` / `.input` styling.
struct DSTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType
    /// Set when this specific field failed validation. Drives both the
    /// visual border and the VoiceOver value, so the error isn't only
    /// discoverable via a caption elsewhere on screen.
    var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.caption)
                .foregroundStyle(DSColor.textSecondary)
                .accessibilityHidden(true)

            TextField(placeholder, text: $text)
                .font(.subheadline)
                .keyboardType(keyboardType)
                .padding(.horizontal, 10)
                .frame(minHeight: 36)
                .background(
                    RoundedRectangle(cornerRadius: DSRadius.md)
                        .strokeBorder(errorMessage == nil ? DSColor.divider : DSColor.accent700, lineWidth: errorMessage == nil ? 1 : 2)
                )
                .accessibilityLabel(label)
                .accessibilityValue(errorMessage ?? text)
        }
    }
}
