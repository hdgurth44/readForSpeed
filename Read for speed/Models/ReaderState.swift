//
//  ReaderState.swift
//  Read for speed
//

import Foundation
import SwiftUI
import Observation

@Observable
class ReaderState {
    var text: String = ""
    var words: [String] = []
    var currentIndex: Int = 0
    var isPlaying: Bool = false
    var wpm: Int = 350
    var isReaderPresented: Bool = false

    static let minWPM = 50
    static let maxWPM = 1000
    static let wpmStep = 50
    static let skipAmount = 10

    // MARK: - Computed Properties

    var currentWord: String {
        guard currentIndex >= 0 && currentIndex < words.count else { return "" }
        return words[currentIndex]
    }

    var wordCount: Int {
        words.count
    }

    var progress: Double {
        guard wordCount > 0 else { return 0 }
        return Double(currentIndex + 1) / Double(wordCount)
    }

    var timeRemaining: TimeInterval {
        guard wordCount > 0 && wpm > 0 else { return 0 }
        let remainingWords = wordCount - currentIndex - 1
        return Double(remainingWords) * 60.0 / Double(wpm)
    }

    var interval: TimeInterval {
        guard wpm > 0 else { return 0.17 }
        return 60.0 / Double(wpm)
    }

    var isAtEnd: Bool {
        currentIndex >= words.count - 1
    }

    var canPlay: Bool {
        !words.isEmpty
    }

    // MARK: - ORP Calculation

    /// Calculates the Optimal Recognition Point (ORP) index for a word.
    /// Based on word length:
    /// - 1 char → 0
    /// - 2-5 chars → 1
    /// - 6-9 chars → 2
    /// - 10-13 chars → 3
    /// - 14+ chars → 4
    static func orpIndex(for word: String) -> Int {
        let length = word.count
        switch length {
        case 1:
            return 0
        case 2...5:
            return 1
        case 6...9:
            return 2
        case 10...13:
            return 3
        default:
            return min(4, length - 1)
        }
    }

    // MARK: - Actions

    func updateText(_ newText: String) {
        text = newText
        words = Tokenizer.tokenize(newText)
        currentIndex = 0
        isPlaying = false
    }

    func play() {
        guard canPlay else { return }
        if isAtEnd {
            currentIndex = 0
        }
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func advance() {
        guard currentIndex < words.count - 1 else {
            isPlaying = false
            return
        }
        currentIndex += 1
    }

    func rewind() {
        currentIndex = max(0, currentIndex - Self.skipAmount)
    }

    func forward() {
        currentIndex = min(words.count - 1, currentIndex + Self.skipAmount)
    }

    func speedUp() {
        wpm = min(Self.maxWPM, wpm + Self.wpmStep)
    }

    func speedDown() {
        wpm = max(Self.minWPM, wpm - Self.wpmStep)
    }

    func restart() {
        currentIndex = 0
        isPlaying = false
    }

    func enterReaderMode() {
        guard canPlay else { return }
        currentIndex = 0
        isPlaying = false
        isReaderPresented = true
    }

    func exitReaderMode() {
        isPlaying = false
        isReaderPresented = false
    }
}
