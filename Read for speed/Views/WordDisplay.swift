//
//  WordDisplay.swift
//  Read for speed
//

import SwiftUI

struct WordDisplay: View {
    let word: String

    private let fontSize: CGFloat = 56

    var body: some View {
        if word.isEmpty {
            Text(" ")
                .font(.system(size: fontSize, design: .monospaced))
        } else {
            HStack(spacing: 0) {
                // Left portion (right-aligned)
                Text(leftPortion)
                    .font(.system(size: fontSize, design: .monospaced))
                    .foregroundColor(Theme.textPrimary)
                    .frame(minWidth: 200, alignment: .trailing)

                // ORP character (highlighted, centered at screen center)
                Text(orpCharacter)
                    .font(.system(size: fontSize, design: .monospaced))
                    .foregroundColor(Theme.orpHighlight)

                // Right portion (left-aligned)
                Text(rightPortion)
                    .font(.system(size: fontSize, design: .monospaced))
                    .foregroundColor(Theme.textPrimary)
                    .frame(minWidth: 200, alignment: .leading)
            }
            .fixedSize()  // Prevent truncation - always display full word
        }
    }

    private var orpIndex: Int {
        ReaderState.orpIndex(for: word)
    }

    private var leftPortion: String {
        guard !word.isEmpty && orpIndex > 0 else { return "" }
        return String(word.prefix(orpIndex))
    }

    private var orpCharacter: String {
        guard !word.isEmpty else { return "" }
        let index = word.index(word.startIndex, offsetBy: orpIndex)
        return String(word[index])
    }

    private var rightPortion: String {
        guard !word.isEmpty && orpIndex < word.count - 1 else { return "" }
        let startIndex = word.index(word.startIndex, offsetBy: orpIndex + 1)
        return String(word[startIndex...])
    }
}

#Preview {
    ZStack {
        Theme.background
        VStack(spacing: 40) {
            WordDisplay(word: "I")
            WordDisplay(word: "am")
            WordDisplay(word: "speed")
            WordDisplay(word: "reading")
            WordDisplay(word: "extraordinary")
        }
    }
}
