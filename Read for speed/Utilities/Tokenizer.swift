//
//  Tokenizer.swift
//  Read for speed
//

import Foundation

enum Tokenizer {
    /// Splits text on whitespace, filtering empty strings.
    /// Preserves punctuation attached to words.
    static func tokenize(_ text: String) -> [String] {
        text.split(whereSeparator: { $0.isWhitespace })
            .map { String($0) }
    }
}
