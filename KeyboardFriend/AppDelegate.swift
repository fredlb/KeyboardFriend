//
//  AppDelegate.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-06.
//

import SwiftUI
import Combine
import KeyboardShortcuts

class AppDelegate:NSObject, NSApplicationDelegate {
    var newEntryPanel: FloatingPanel!
    var qmkInfoService: QMKInfoService = QMKInfoService()
    var kfKeyboardStore: KFKeyboardStore = KFKeyboardStore()
    var isPanelShowing: Bool = false
    
    var changeSink: AnyCancellable?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        changeSink = kfKeyboardStore.$shortcuts.sink {
            self.setupListeners(shortcuts: $0)
        }
        
    }
    
    private func setupListeners(shortcuts: [String:Shortcut]) {
        print("All kfShortcuts:\(shortcuts)")
        KeyboardShortcuts.removeAllHandlers()
        for shortcut in Array(shortcuts) {
            KeyboardShortcuts.onKeyUp(for: shortcut.value.name) {
                print("keyUp on \(shortcut.value.id)")
                if !self.isPanelShowing {
                    let activeLayout = self.kfKeyboardStore.activeKeyboard?.settings.activeLayout
                    self.createFloatingPanel(layer: shortcut.key, drawLayout: (self.kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == activeLayout})!)
                    self.newEntryPanel.center()
                    self.newEntryPanel.orderFront(nil)
                    self.isPanelShowing = true
                } else {
                    self.newEntryPanel?.close()
                    self.newEntryPanel = nil
                    self.isPanelShowing = false
                }
            }
        }
    }
    
    private func createFloatingPanel(layer: String, drawLayout: DrawLayout) {
        let contentView = KeyboardView(maxWidth: drawLayout.keyboardWidth, maxHeight: drawLayout.keyboardHeigt, layer: drawLayout.layers[layer]!).edgesIgnoringSafeArea(.top).padding()
        
        newEntryPanel = FloatingPanel(contentRect: NSRect(x:0, y:0, width: 512, height: 256), backing: .buffered, defer: false)
        newEntryPanel.contentView = NSHostingView(rootView: contentView)
    }
    
}
