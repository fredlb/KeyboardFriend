//
//  KeebDrawTestApp.swift
//  KeebDrawTest
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import SwiftUI

@main
struct KeyboardFriendApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SettingsView().environmentObject(appDelegate.qmkInfoService)
        }
        MenuBarExtra("KEEB") {
            Button("Settings"){
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                NSApp.activate(ignoringOtherApps: true)
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
