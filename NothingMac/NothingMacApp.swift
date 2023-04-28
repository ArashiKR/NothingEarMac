//
//  NothingMacApp.swift
//  NothingMac
//
//  Created by Joe on 28/04/2023.
//

import SwiftUI

@main
struct NothingMacApp: App {
    let nothing = NothingProtocol()
    
    init() {
        nothing.connect()
    }
    
    var body: some Scene {
        MenuBarExtra("Nothing Ear") {
            Button("Noise Cancelling") {
                nothing.setANC(mode: NothingANCMode.Adaptive)
            }
            Button("Transparancy") {
                nothing.setANC(mode: NothingANCMode.Transparency)
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
