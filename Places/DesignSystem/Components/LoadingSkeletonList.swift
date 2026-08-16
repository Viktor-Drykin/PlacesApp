//
//  LoadingSkeletonList.swift
//  Places
//

import SwiftUI

private struct ShimmerModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    LinearGradient(
                        colors: [DSColor.Neutral.n200, DSColor.Neutral.n100, DSColor.Neutral.n200],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: reduceMotion ? 0 : phase * proxy.size.width)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

private extension View {
    func shimmering() -> some View { modifier(ShimmerModifier()) }
}

struct LoadingSkeletonList: View {
    let accessibilityLabel: String
    var rowCount: Int = 5

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rowCount, id: \.self) { _ in
                HStack(spacing: 12) {
                    Circle()
                        .fill(DSColor.Neutral.n200)
                        .frame(width: 38, height: 38)
                        .shimmering()

                    VStack(alignment: .leading, spacing: 7) {
                        Rectangle()
                            .fill(DSColor.Neutral.n200)
                            .frame(width: 120, height: 13)
                            .shimmering()
                        Rectangle()
                            .fill(DSColor.Neutral.n200)
                            .frame(width: 80, height: 10)
                            .shimmering()
                    }

                    Spacer()
                }
                .padding(.vertical, 14)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.updatesFrequently)
    }
}
