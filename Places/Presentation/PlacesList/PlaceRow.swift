//
//  PlaceRow.swift
//  Places
//

import SwiftUI

struct PlaceRow: View {
    let name: String
    let coordinatesText: String
    let accessibilityHint: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .strokeBorder(DSColor.accent, lineWidth: 1.5)
                    .frame(width: 38, height: 38)
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(DSColor.accent700)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(name)
                    .font(.body)
                    .fontDesign(.serif)
                    .fontWeight(.semibold)
                    .foregroundStyle(DSColor.text)
                Text(coordinatesText)
                    .font(.footnote)
                    .monospacedDigit()
                    .foregroundStyle(DSColor.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(DSColor.textTertiary)
        }
        .padding(.vertical, 13)
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(name)
        .accessibilityValue(coordinatesText)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(accessibilityHint)
    }
}
