//
//  Read_for_speedApp.swift
//  Read for speed
//
//  Created by harry angeles on 1/19/26.
//

import SwiftUI

@main
struct Read_for_speedApp: App {
    @AppStorage("defaultWPM") private var defaultWPM = 350
    @State private var readerState: ReaderState?

    var body: some Scene {
        WindowGroup {
            ZStack {
                if let state = readerState {
                    if state.isReaderPresented {
                        ReaderView(state: state)
                    } else {
                        EditorView(state: state)
                    }
                }
            }
            .frame(minWidth: 400, minHeight: 300)
            .preferredColorScheme(.dark)
            .onAppear {
                if readerState == nil {
                    readerState = ReaderState(defaultWPM: defaultWPM)
                }
            }
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .textEditing) {
                Button("Start Reading") {
                    readerState?.enterReaderMode()
                }
                .keyboardShortcut(.return, modifiers: .command)
                .disabled(readerState?.canPlay != true)
            }
        }

        Settings {
            SettingsView()
        }
    }
}
