//
//  ReaderView.swift
//  Read for speed
//

import SwiftUI
import Combine
import AppKit

struct ReaderView: View {
    var state: ReaderState
    @State private var cursorHidden = false
    @State private var cursorHideTimer: Timer?

    private let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.1) // #1a1a1a
    private let guideLineColor = Color(red: 0.267, green: 0.267, blue: 0.267) // #444444
    private let pivotColor = Color(red: 0.4, green: 0.4, blue: 0.4) // #666666

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Guide lines and word display
                ZStack {
                    // Vertical guide lines
                    Rectangle()
                        .fill(guideLineColor)
                        .frame(width: 1, height: 80)

                    // Pivot markers (small triangles pointing at ORP)
                    VStack {
                        // Top marker
                        Triangle()
                            .fill(pivotColor)
                            .frame(width: 10, height: 6)
                            .rotationEffect(.degrees(180))

                        Spacer()
                            .frame(height: 68)

                        // Bottom marker
                        Triangle()
                            .fill(pivotColor)
                            .frame(width: 10, height: 6)
                    }

                    // Word display centered at ORP
                    WordDisplay(word: state.currentWord)
                }

                Spacer()

                // Status bar
                statusBar
            }
        }
        .onAppear {
            setupKeyboardHandler()
            startCursorHideTimer()
        }
        .onDisappear {
            cleanupKeyboardHandler()
            showCursor()
        }
        .onReceive(timer) { _ in
            if state.isPlaying {
                state.advance()
            }
        }
        .onContinuousHover { phase in
            switch phase {
            case .active:
                resetCursorHideTimer()
            case .ended:
                break
            }
        }
    }

    // MARK: - Timer

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: state.interval, on: .main, in: .common).autoconnect()
    }

    // MARK: - Status Bar

    private var statusBar: some View {
        HStack {
            // Play/Pause indicator
            Image(systemName: state.isPlaying ? "play.fill" : "pause.fill")
                .foregroundColor(.gray)

            Spacer()

            // Status text
            if state.isAtEnd && !state.isPlaying {
                Text("Complete")
                    .foregroundColor(.green)
                    .font(.system(size: 12, design: .monospaced))
            }

            Spacer()

            // WPM
            Text("\(state.wpm) WPM")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.gray)

            Spacer()

            // Progress
            Text("\(state.currentIndex + 1)/\(state.wordCount)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.gray)

            Spacer()

            // Time remaining
            Text(formatTime(state.timeRemaining))
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(white: 0.12))
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }

    // MARK: - Keyboard Handling

    @State private var keyboardMonitor: Any?

    private func setupKeyboardHandler() {
        keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            handleKeyEvent(event)
            return nil
        }
    }

    private func cleanupKeyboardHandler() {
        if let monitor = keyboardMonitor {
            NSEvent.removeMonitor(monitor)
            keyboardMonitor = nil
        }
    }

    private func handleKeyEvent(_ event: NSEvent) {
        let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

        switch event.keyCode {
        case 49: // Space
            state.togglePlayPause()

        case 53: // Escape
            state.exitReaderMode()

        case 123: // Left arrow
            state.rewind()

        case 124: // Right arrow
            state.forward()

        case 126: // Up arrow (with Cmd)
            if modifiers.contains(.command) {
                state.speedUp()
            }

        case 125: // Down arrow (with Cmd)
            if modifiers.contains(.command) {
                state.speedDown()
            }

        case 30: // ] key
            state.speedUp()

        case 33: // [ key
            state.speedDown()

        case 15: // R key
            state.restart()

        default:
            break
        }
    }

    // MARK: - Cursor Auto-Hide

    private func startCursorHideTimer() {
        cursorHideTimer?.invalidate()
        cursorHideTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            hideCursor()
        }
    }

    private func resetCursorHideTimer() {
        showCursor()
        startCursorHideTimer()
    }

    private func hideCursor() {
        if !cursorHidden {
            NSCursor.hide()
            cursorHidden = true
        }
    }

    private func showCursor() {
        cursorHideTimer?.invalidate()
        if cursorHidden {
            NSCursor.unhide()
            cursorHidden = false
        }
    }
}

// MARK: - Triangle Shape

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    let state = ReaderState()
    state.updateText("This is a test of the speed reading application with multiple words to display.")
    return ReaderView(state: state)
        .frame(width: 800, height: 600)
}
