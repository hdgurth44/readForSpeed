//
//  EditorView.swift
//  Read for speed
//

import SwiftUI

struct EditorView: View {
    @Bindable var state: ReaderState

    private let introText = """
    Speed reading helps you read faster by showing one word at a time.

    Your eyes stay fixed while words flow past.

    Press Start Reading to try it.

    Use Space to pause and Escape to exit when done.
    """

    var body: some View {
        Group {
            if state.text.isEmpty {
                EmptyStateView(
                    onGetStarted: loadIntroText
                )
            } else {
                editorContent
            }
        }
        .background(Theme.background)
    }

    private func loadIntroText() {
        state.updateText(introText)
    }

    private var editorContent: some View {
        VStack(spacing: 0) {
            // Text Editor
            PaddedTextEditor(text: $state.text)
                .onChange(of: state.text) { _, newValue in
                    state.updateText(newValue)
                }

            // Bottom bar
            HStack {
                // Left: Word count
                Text("\(state.wordCount) words")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Theme.textSecondary)

                Spacer()

                // Center: Shortcuts
                Text("⌘Return to start  |  ⌘, for settings")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Theme.textSecondary)

                Spacer()

                // Right: Buttons
                HStack {
                    // Fix Formatting button
                    Button(action: { state.fixFormatting() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "textformat")
                            Text("Fix Formatting")
                        }
                        .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.bordered)
                    .disabled(state.text.isEmpty)

                    // Play button
                    Button(action: {
                        state.enterReaderMode()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "play.fill")
                            Text("Start Reading")
                        }
                        .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.indigo700)
                    .disabled(!state.canPlay)
                    .keyboardShortcut(.return, modifiers: .command)
                }
            }
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(Theme.surfaceElevated)
        }
    }

}

#Preview {
    EditorView(state: ReaderState())
        .frame(width: 600, height: 400)
}
