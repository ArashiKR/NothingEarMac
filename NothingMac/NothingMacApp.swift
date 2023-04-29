//
//  NothingMacApp.swift
//  NothingMac
//
//  Created by Joe on 28/04/2023.
//

import SwiftUI
import KeyboardShortcuts

let nothing = NothingProtocol()

@main
struct NothingMacApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
        ProcessInfo.processInfo.disableSuddenTermination()
    }
    
    var body: some Scene {
        Settings {
            SettingsScreen()
        }
        MenuBarExtra("Nothing Ear") {
            Button("Noise Cancelling") {
                nothing.setANC(mode: NothingANCMode.Adaptive)
            }
            Button("Transparency") {
                nothing.setANC(mode: NothingANCMode.Transparency)
            }
            Divider()
            Button("Settings") {
                if #available(macOS 13, *) {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                } else {
                    NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                }
            }
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    init() {
        KeyboardShortcuts.onKeyUp(for: .noiseCancelling) { [self] in
            nothing.setANC(mode: NothingANCMode.Adaptive)
        }
        KeyboardShortcuts.onKeyUp(for: .transparency) { [self] in
            nothing.setANC(mode: NothingANCMode.Transparency)
        }
    }
}
