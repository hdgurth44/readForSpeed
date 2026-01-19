//
//  GeneralSettingsView.swift
//  Read for speed
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("defaultWPM") private var defaultWPM = 350

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Default Reading Speed")
                        Spacer()
                        Text("\(defaultWPM) WPM")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }

                    Slider(
                        value: Binding(
                            get: { Double(defaultWPM) },
                            set: { defaultWPM = Int($0) }
                        ),
                        in: Double(ReaderState.minWPM)...Double(ReaderState.maxWPM),
                        step: Double(ReaderState.wpmStep)
                    )
                }
            } footer: {
                Text("This speed will be used when starting a new reading session.")
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    GeneralSettingsView()
        .frame(width: 450, height: 200)
}
