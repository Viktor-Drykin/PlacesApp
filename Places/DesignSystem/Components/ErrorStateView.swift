//
//  ErrorStateView.swift
//  Places
//

import SwiftUI

struct ErrorStateView: View {
    let title: String
    let message: String
    let retryTitle: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(DSColor.accent700)

                Text(title)
                    .font(.title3)
                    .fontDesign(.serif)
                    .fontWeight(.semibold)
                    .foregroundStyle(DSColor.text)
                    .accessibilityAddTraits(.isHeader)

                Text(message)
                    .font(.footnote)
                    .foregroundStyle(DSColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 220)
            }
            .accessibilityElement(children: .combine)

            Button(retryTitle, action: onRetry)
                .buttonStyle(.dsPrimary)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}
