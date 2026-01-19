//
//  EmptyStateView.swift
//  Read for speed
//

import SwiftUI

struct EmptyStateView: View {
    let onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Image("speed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160, height: 160)

                Text("Welcome to Read for Speed")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Button("Get started") {
                    onGetStarted()
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.indigo700)
            }

            Spacer()

            // Bottom bar with keyboard shortcuts
            HStack {
                Text("⌘Return to start  |  ⌘, for settings")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Theme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(Theme.surfaceElevated)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
}

#Preview {
    EmptyStateView(onGetStarted: {})
        .frame(width: 600, height: 500)
}
