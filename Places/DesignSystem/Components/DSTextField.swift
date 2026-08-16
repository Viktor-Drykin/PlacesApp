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
                        .strokeBorder(DSColor.divider, lineWidth: 1)
                )
                .accessibilityLabel(label)
        }
    }
}
