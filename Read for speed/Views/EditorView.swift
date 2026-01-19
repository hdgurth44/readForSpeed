//
//  EditorView.swift
//  Read for speed
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct EditorView: View {
    @Bindable var state: ReaderState

    var body: some View {
        Group {
            if state.text.isEmpty {
                EmptyStateView(
                    onOpenFile: openFile,
                    onPasteFromClipboard: pasteFromClipboard
                )
            } else {
                editorContent
            }
        }
        .background(Theme.background)
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
                // Word count
                Text("\(state.wordCount) words")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Theme.textSecondary)

                Spacer()

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
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Theme.surfaceElevated)
        }
    }

    private func openFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.plainText]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK, let url = panel.url {
            if let content = try? String(contentsOf: url, encoding: .utf8) {
                state.text = content
                state.updateText(content)
            }
        }
    }

    private func pasteFromClipboard() {
        if let content = NSPasteboard.general.string(forType: .string) {
            state.text = content
            state.updateText(content)
        }
    }
}

#Preview {
    EditorView(state: ReaderState())
        .frame(width: 600, height: 400)
}
