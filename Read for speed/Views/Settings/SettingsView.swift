//
//  SettingsView.swift
//  Read for speed
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            SupportSettingsView()
                .tabItem {
                    Label("Support", systemImage: "questionmark.circle")
                }
        }
        .frame(width: 450, height: 250)
    }
}

#Preview {
    SettingsView()
}
