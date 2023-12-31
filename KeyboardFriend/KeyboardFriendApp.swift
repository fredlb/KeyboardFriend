//
//  KeyboardFriendApp.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import SwiftUI

@main
struct KeyboardFriendApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.openWindow) var openWindow
    
    var body: some Scene {
        WindowGroup(id: "settings-view") {
            SettingsView()
                .environmentObject(appDelegate.qmkInfoService)
                .environmentObject(appDelegate.kfKeyboardStore)
        }
        MenuBarExtra("KF", systemImage: "keyboard.badge.eye") {
            Button("Settings"){
                openWindow(id: "settings-view")
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
