//
//  EditorView.swift
//  Read for speed
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct EditorView: View {
    @Bindable var state: ReaderState

    private let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.1) // #1a1a1a

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
        .background(backgroundColor)
    }

    private var editorContent: some View {
        VStack(spacing: 0) {
            // Text Editor
            TextEditor(text: $state.text)
                .font(.system(size: 14, design: .monospaced))
                .scrollContentBackground(.hidden)
                .background(backgroundColor)
                .foregroundColor(.white)
                .onChange(of: state.text) { _, newValue in
                    state.updateText(newValue)
                }

            // Bottom bar
            HStack {
                // Word count
                Text("\(state.wordCount) words")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.gray)

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
                .disabled(!state.canPlay)
                .keyboardShortcut(.return, modifiers: .command)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(white: 0.15))
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
