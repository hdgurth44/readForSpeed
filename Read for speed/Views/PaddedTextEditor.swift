//
//  PaddedTextEditor.swift
//  Read for speed
//

import SwiftUI
import AppKit

struct PaddedTextEditor: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        // Configure text view
        textView.delegate = context.coordinator
        textView.font = NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.textColor = NSColor(Theme.textPrimary)
        textView.backgroundColor = NSColor(Theme.background)
        textView.string = text
        textView.isRichText = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true

        // CRITICAL: Set internal padding (typewriter margins)
        textView.textContainerInset = NSSize(width: 40, height: 32)

        // Auto-resize text view with scroll view
        textView.autoresizingMask = [.width]
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.textContainer?.widthTracksTextView = true

        // Configure scroll view
        scrollView.documentView = textView
        scrollView.drawsBackground = true
        scrollView.backgroundColor = NSColor(Theme.background)
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        if textView.string != text {
            textView.string = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                text.wrappedValue = textView.string
            }
        }
    }
}
