//
//  AppDelegate.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-06.
//

import SwiftUI

class AppDelegate:NSObject, NSApplicationDelegate {
    var newEntryPanel: FloatingPanel!
    var qmkInfoService: QMKInfoService = QMKInfoService()
    @StateObject var kfKeyboardStore: KFKeyboardStore = KFKeyboardStore.shared
    var isPanelShowing: Bool = false
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let prompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options: NSDictionary = [prompt: true]
        let appHasPermission = AXIsProcessTrustedWithOptions(options)
        if appHasPermission {
            NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
                let hold = self.qmkInfoService.holdHotkey
                if hold {
                    self.handleHoldHotkeys(event: event)
                } else {
                    self.handlePersistantHotkey(event: event)
                }
            }
            
            NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { event in
                let hold = self.qmkInfoService.holdHotkey
                if hold {
                    self.handleHoldHotkeys(event: event)
                }
            }
        }
    }
    
    private func createFloatingPanel(layer: String, drawLayout: DrawLayout) {
        let contentView = KeyboardView(maxWidth: drawLayout.keyboardWidth, maxHeight: drawLayout.keyboardHeigt, layer: drawLayout.layers[layer]!).edgesIgnoringSafeArea(.top).padding()
        
        newEntryPanel = FloatingPanel(contentRect: NSRect(x:0, y:0, width: 512, height: 256), backing: .buffered, defer: false)
        newEntryPanel.contentView = NSHostingView(rootView: contentView)
    }
    
    private func handleHoldHotkeys(event: NSEvent) {
        let currentHotkeys = kfKeyboardStore.activeKeyboard?.settings.hotkeys
        
        if event.type == .keyDown {
            for hotkey in currentHotkeys ?? [:] {
                if event.keyCode == hotkey.value.keycode {
                    if !self.isPanelShowing {
                        let activeLayout = kfKeyboardStore.activeKeyboard?.settings.activeLayout
                        self.createFloatingPanel(layer: hotkey.key, drawLayout: (kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == activeLayout})!)
                        self.newEntryPanel.center()
                        self.newEntryPanel.orderFront(nil)
                        self.isPanelShowing = true
                    }
                }
            }
        } else if event.type == .keyUp {
            for hotkey in currentHotkeys ?? [:] {
                if event.keyCode == hotkey.value.keycode {
                    self.newEntryPanel?.close()
                    self.newEntryPanel = nil
                    self.isPanelShowing = false
                }
            }
        }
    }
    
    private func handlePersistantHotkey(event: NSEvent) {
        let currentHotkeys = kfKeyboardStore.activeKeyboard?.settings.hotkeys
        for hotkey in currentHotkeys ?? [:] {
            if event.keyCode == hotkey.value.keycode {
                if !self.isPanelShowing {
                    let activeLayout = kfKeyboardStore.activeKeyboard?.settings.activeLayout
                    self.createFloatingPanel(layer: hotkey.key, drawLayout: (kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == activeLayout})!)
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
    
}
