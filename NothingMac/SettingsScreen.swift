//
//  Settings.swift
//  NothingEarMac
//
//  Created by Joe on 29/04/2023.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsScreen: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("ANC Toggle:", name: .noiseCancelling)
            KeyboardShortcuts.Recorder("Transparency Mode:", name: .transparency)
        }
    }
}
