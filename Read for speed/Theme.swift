//
//  Theme.swift
//  Read for speed
//

import SwiftUI

/// Centralized color theme using an indigo palette
/// All colors are selected to meet WCAG AA contrast requirements (4.5:1 minimum)
enum Theme {
    // MARK: - Indigo Palette

    /// #131738 - Deepest indigo, primary background
    static let indigo950 = Color(red: 0.075, green: 0.090, blue: 0.220)

    /// #283593 - Dark indigo, secondary backgrounds
    static let indigo800 = Color(red: 0.157, green: 0.208, blue: 0.576)

    /// #3849AB - Medium-dark indigo, accent elements
    static let indigo700 = Color(red: 0.220, green: 0.286, blue: 0.671)

    /// #7986CB - Medium indigo, highlights and focus elements
    static let indigo400 = Color(red: 0.475, green: 0.525, blue: 0.796)

    /// #9FA8DA - Light indigo, secondary text on dark
    static let indigo300 = Color(red: 0.624, green: 0.659, blue: 0.855)

    /// #C5CAE9 - Lighter indigo, primary text on dark backgrounds
    static let indigo200 = Color(red: 0.773, green: 0.792, blue: 0.914)

    /// #E8EAF6 - Lightest indigo, high-contrast text
    static let indigo100 = Color(red: 0.910, green: 0.918, blue: 0.965)

    // MARK: - Semantic Colors

    /// Main app background (indigo/950)
    /// Contrast with indigo100: ~12:1 ✓
    static let background = indigo950

    /// Status bar and panel backgrounds (indigo/800)
    /// Provides visual hierarchy while staying in palette
    static let surfaceElevated = indigo800

    /// Primary text color (indigo/100)
    /// Ensures WCAG AAA contrast (7:1+) on background
    static let textPrimary = indigo100

    /// Secondary/muted text (indigo/300)
    /// WCAG AA compliant on dark backgrounds
    static let textSecondary = indigo300

    /// ORP highlight color (indigo/400)
    /// High visibility focal point with good contrast
    static let orpHighlight = indigo400

    /// Guide lines and subtle dividers (indigo/700)
    static let guideLine = indigo700

    /// Pivot markers (indigo/400)
    static let pivotMarker = indigo400

    /// Success/completion state
    static let success = Color(red: 0.4, green: 0.8, blue: 0.6)

    /// Card/panel background with subtle contrast
    static let cardBackground = indigo800.opacity(0.5)
}
