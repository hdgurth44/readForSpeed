//
//  SupportSettingsView.swift
//  Read for speed
//

import SwiftUI
import AppKit

struct SupportSettingsView: View {
    var body: some View {
        Form {
            Section {
                Button {
                    reportBug()
                } label: {
                    Label("Report a Bug", systemImage: "ladybug")
                }
                .buttonStyle(.link)

                Button {
                    suggestFeature()
                } label: {
                    Label("Suggest a Feature", systemImage: "lightbulb")
                }
                .buttonStyle(.link)
            } header: {
                Text("Feedback")
            }

            Section {
                LabeledContent("Version") {
                    Text(appVersion)
                        .foregroundStyle(.secondary)
                }

                LabeledContent("Build") {
                    Text(buildNumber)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("About")
            }
        }
        .formStyle(.grouped)
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }

    private func reportBug() {
        let subject = "Read for Speed Bug Report"
        let body = """
        Hi Harry,

        I found a bug in Read for Speed:

        **What I expected:**


        **What happened instead:**


        **Steps to reproduce:**
        1.

        **macOS version:**

        Thanks!
        """
        openEmail(subject: subject, body: body)
    }

    private func suggestFeature() {
        let subject = "Read for Speed Feature Suggestion"
        let body = """
        Hi Harry,

        I have a feature suggestion for Read for Speed:

        **Feature idea:**


        **Why it would be useful:**


        Thanks!
        """
        openEmail(subject: subject, body: body)
    }

    private func openEmail(subject: String, body: String) {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "mailto:harrydangeles@gmail.com?subject=\(encodedSubject)&body=\(encodedBody)") {
            NSWorkspace.shared.open(url)
        }
    }
}

#Preview {
    SupportSettingsView()
        .frame(width: 450, height: 300)
}
