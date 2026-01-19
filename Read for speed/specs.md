# Speed Reader Mac App Specification

## Overview

A minimal macOS app with two modes:
1. **Editor Mode**: Simple markdown text editor for pasting/editing text
2. **Reader Mode**: Full-screen RSVP (Rapid Serial Visual Presentation) speed reader with ORP highlighting

## Core Concept: RSVP with ORP

RSVP displays one word at a time at a fixed position. The key innovation is **ORP (Optimal Recognition Point)** highlighting - each word has one letter highlighted in red at the screen's center, allowing the eye to stay fixed while words flash by.

### ORP Algorithm

The ORP position is approximately 25% into the word, based on length:

```
Word Length → ORP Index (0-based)
1 char      → 0
2-5 chars   → 1
6-9 chars   → 2
10-13 chars → 3
14+ chars   → 4
```

Example words with ORP marked in brackets:
- "I" → "[I]"
- "the" → "t[h]e"
- "reading" → "re[a]ding"
- "comprehensive" → "com[p]rehensive"

## User Interface

### Editor Mode (Default/Launch State)

A simple window with:
- **Text area**: Monospace font, dark theme, for pasting/editing text
- **Word count**: Display total words at bottom
- **Play button**: Large, prominent button to launch reader mode
- **Keyboard shortcut**: `⌘Enter` to start reading

No markdown rendering needed - just plain text editing. The "markdown editor" framing is for familiar UX, but render as plain text.

### Reader Mode (Full-Screen)

Full-screen dark display showing:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                           │ (pivot marker)                  │
│     ─────────────────────────────────────────── (guide)     │
│                                                             │
│                    compre[h]ensive                          │
│                                                             │
│     ─────────────────────────────────────────── (guide)     │
│                           │ (pivot marker)                  │
│                                                             │
│  ▶ 350 WPM                              142/500 · 1:02 left │
└─────────────────────────────────────────────────────────────┘
```

#### Visual Elements

1. **Word Display**
   - Large monospace font (48-64pt)
   - White text on dark background (#1a1a1a)
   - ORP letter highlighted in red (#ff4444)
   - Word positioned so ORP letter is always at screen center

2. **Guide Lines**
   - Horizontal lines above and below the word
   - Subtle gray (#444444)
   - Help eyes stay fixed at center

3. **Pivot Marker**
   - Short vertical lines at center, above top guide and below bottom guide
   - Slightly lighter gray (#666666)
   - Marks the exact fixation point

4. **Status Bar** (bottom of screen, subtle)
   - Play/pause indicator
   - Current WPM
   - Progress: "current/total"
   - Time remaining: "X:XX left"

#### Controls

| Action | Shortcut |
|--------|----------|
| Play/Pause | `Space` |
| Exit to Editor | `Escape` |
| Rewind 10 words | `←` |
| Forward 10 words | `→` |
| Speed up (+50 WPM) | `⌘↑` or `]` |
| Slow down (-50 WPM) | `⌘↓` or `[` |
| Restart from beginning | `R` |

## State Management

```swift
struct SpeedReaderState {
    var text: String           // Raw text from editor
    var words: [String]        // Tokenized words
    var currentIndex: Int      // Current word position (0-based)
    var isPlaying: Bool        // Play/pause state
    var wpm: Int               // Words per minute
}
```

### Default Values
- WPM: 350 (range: 50-1000, step: 50)
- Start paused on first word when entering reader mode

## Text Tokenization

Simple whitespace splitting with cleanup:
1. Trim the input text
2. Replace multiple whitespace with single space
3. Split on spaces
4. Filter out empty strings

Keep punctuation attached to words (e.g., "Hello," stays as one token).

## Timing Calculation

```
Interval (ms) = (60 / WPM) * 1000

Example: 350 WPM → 171ms per word
```

Time remaining:
```
Remaining seconds = (wordsLeft / WPM) * 60
Format as "M:SS"
```

## Technical Recommendations

### SwiftUI Approach
- Use `@State` for local state management
- `Timer.publish` for word advancement
- `.fullScreenCover()` for reader mode
- `NSEvent.addLocalMonitorForEvents` for keyboard shortcuts in full-screen

### Text Rendering
- Use native `Text` view with `AttributedString` for ORP coloring
- Monospace font: `Font.system(.largeTitle, design: .monospaced)`
- No need for SVG - native text is cleaner on macOS

### Window Management
- Editor: Standard resizable window (min 400x300)
- Reader: True full-screen, hide cursor after 2s of inactivity

## Edge Cases

1. **Empty text**: Disable play button, show placeholder text
2. **Single word**: Show it, immediately complete on play
3. **End of text**: Auto-pause on last word, show "Complete" state
4. **Very long words**: May extend beyond guide lines - that's okay

## File Structure Suggestion

```
SpeedReader/
├── SpeedReaderApp.swift      # App entry point
├── Models/
│   └── ReaderState.swift     # State and ORP logic
├── Views/
│   ├── EditorView.swift      # Main editor window
│   ├── ReaderView.swift      # Full-screen reader
│   └── WordDisplay.swift     # ORP-highlighted word component
└── Utilities/
    └── Tokenizer.swift       # Text tokenization
```

## MVP Scope

### Include
- Paste/edit text in editor
- Full-screen RSVP reader with ORP
- Play/pause/speed controls
- Progress display

### Exclude (Future)
- File open/save
- Light mode / theme options
- Sentence-aware pausing (pause longer on periods)
- Import from clipboard automatically
- Preferences window
- Menu bar integration
