//
//  MarkdownStripper.swift
//  Read for speed
//

import Foundation

enum MarkdownStripper {
    /// Strips markdown formatting from text, returning plain text.
    static func strip(_ text: String) -> String {
        var result = text

        // Remove code blocks (triple backticks with optional language)
        result = result.replacingOccurrences(
            of: "```[a-zA-Z]*\\n[\\s\\S]*?```",
            with: "",
            options: .regularExpression
        )

        // Remove inline code (single backticks)
        result = result.replacingOccurrences(
            of: "`([^`]+)`",
            with: "$1",
            options: .regularExpression
        )

        // Remove images: ![alt](url) → alt
        result = result.replacingOccurrences(
            of: "!\\[([^\\]]*)\\]\\([^)]+\\)",
            with: "$1",
            options: .regularExpression
        )

        // Remove links: [text](url) → text
        result = result.replacingOccurrences(
            of: "\\[([^\\]]+)\\]\\([^)]+\\)",
            with: "$1",
            options: .regularExpression
        )

        // Remove headers (# through ######)
        result = result.replacingOccurrences(
            of: "(?m)^#{1,6}\\s+",
            with: "",
            options: .regularExpression
        )

        // Remove horizontal rules (---, ***, ___)
        result = result.replacingOccurrences(
            of: "(?m)^[-*_]{3,}\\s*$",
            with: "",
            options: .regularExpression
        )

        // Remove blockquotes (> )
        result = result.replacingOccurrences(
            of: "(?m)^>\\s?",
            with: "",
            options: .regularExpression
        )

        // Remove bullet points (-, *, +)
        result = result.replacingOccurrences(
            of: "(?m)^\\s*[-*+]\\s+",
            with: "",
            options: .regularExpression
        )

        // Remove numbered lists (1. , 2. , etc.)
        result = result.replacingOccurrences(
            of: "(?m)^\\s*\\d+\\.\\s+",
            with: "",
            options: .regularExpression
        )

        // Remove strikethrough (~~text~~)
        result = result.replacingOccurrences(
            of: "~~([^~]+)~~",
            with: "$1",
            options: .regularExpression
        )

        // Remove bold (**text** or __text__)
        result = result.replacingOccurrences(
            of: "\\*\\*([^*]+)\\*\\*",
            with: "$1",
            options: .regularExpression
        )
        result = result.replacingOccurrences(
            of: "__([^_]+)__",
            with: "$1",
            options: .regularExpression
        )

        // Remove italic (*text* or _text_)
        // Be careful not to match underscores in words
        result = result.replacingOccurrences(
            of: "(?<![\\w*])\\*([^*]+)\\*(?![\\w*])",
            with: "$1",
            options: .regularExpression
        )
        result = result.replacingOccurrences(
            of: "(?<![\\w_])_([^_]+)_(?![\\w_])",
            with: "$1",
            options: .regularExpression
        )

        // Normalize excessive whitespace (multiple blank lines → single)
        result = result.replacingOccurrences(
            of: "\\n{3,}",
            with: "\n\n",
            options: .regularExpression
        )

        // Trim leading/trailing whitespace
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)

        return result
    }
}
