//
//  Read_for_speedApp.swift
//  Read for speed
//
//  Created by harry angeles on 1/19/26.
//

import SwiftUI

@main
struct Read_for_speedApp: App {
    @State private var readerState = ReaderState()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if readerState.isReaderPresented {
                    ReaderView(state: readerState)
                } else {
                    EditorView(state: readerState)
                }
            }
            .frame(minWidth: 400, minHeight: 300)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .textEditing) {
                Button("Start Reading") {
                    readerState.enterReaderMode()
                }
                .keyboardShortcut(.return, modifiers: .command)
                .disabled(!readerState.canPlay)
            }
        }
    }
}
