//
//  EmptyStateView.swift
//  Places
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkles")
                .font(.system(size: 30, weight: .light))
                .foregroundStyle(DSColor.accent)

            Text(title)
                .font(.title3)
                .fontDesign(.serif)
                .fontWeight(.semibold)
                .foregroundStyle(DSColor.text)

            Text(message)
                .font(.footnote)
                .foregroundStyle(DSColor.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 220)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
        .accessibilityElement(children: .combine)
    }
}
