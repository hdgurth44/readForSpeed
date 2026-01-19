//
//  EmptyStateView.swift
//  Read for speed
//

import SwiftUI

struct EmptyStateView: View {
    let onOpenFile: () -> Void
    let onPasteFromClipboard: () -> Void

    private let steps = [
        "Paste or type your text in the editor",
        "Press Start Reading or use ⌘Return",
        "Use Space to pause, arrows to navigate, [ ] to adjust speed"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Image("speed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)

            Text("Welcome to Read for Speed")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(Theme.textPrimary)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1).")
                            .font(.body.monospaced())
                            .foregroundStyle(Theme.textSecondary)
                        Text(step)
                            .font(.body)
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .padding(20)
            .background(Theme.cardBackground)
            .cornerRadius(12)

            HStack(spacing: 16) {
                Button("Open File") {
                    onOpenFile()
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.indigo700)

                Button("Paste from Clipboard") {
                    onPasteFromClipboard()
                }
                .buttonStyle(.bordered)
                .tint(Theme.indigo400)
            }

            Text("⌘Return to start  |  ⌘, for settings")
                .font(.callout)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
}

#Preview {
    EmptyStateView(onOpenFile: {}, onPasteFromClipboard: {})
        .frame(width: 600, height: 500)
}
