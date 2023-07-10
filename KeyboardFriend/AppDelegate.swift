//
//  AppDelegate.swift
//  KeebDrawTest
//
//  Created by Fredrik Lindner on 2023-07-06.
//

import SwiftUI

class AppDelegate:NSObject, NSApplicationDelegate {
    var newEntryPanel: FloatingPanel!
    var qmkInfoService: QMKInfoService = QMKInfoService()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Close main app window
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        let prompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options: NSDictionary = [prompt: true]
        let appHasPermission = AXIsProcessTrustedWithOptions(options)
        if appHasPermission {
            NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
                let currentHotkeys = self.qmkInfoService.hotkeys
                let hold = self.qmkInfoService.holdHotkey
                if hold {
                    self.handleHoldHotkeys(event: event)
                } else {
                    self.handlePersistantHotkey(event: event)
                }
            }
            
            NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { event in
                let currentHotkeys = self.qmkInfoService.hotkeys
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
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            let currentHotkeys = self.qmkInfoService.hotkeys
            for hotkey in Array(currentHotkeys) {
                if event.keyCode == hotkey.value {
                    if !(self.newEntryPanel?.isVisible ?? false) {
                        self.createFloatingPanel(layer: hotkey.key, drawLayout: self.qmkInfoService.currentDrawLayout)
                        self.newEntryPanel.center()
                        self.newEntryPanel.orderFront(nil)
                    }
                }
            }
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { event in
            let currentHotkeys = self.qmkInfoService.hotkeys
            for hotkey in Array(currentHotkeys) {
                print(hotkey)
                if event.keyCode == hotkey.value {
                    self.newEntryPanel?.close()
                    self.newEntryPanel = nil
                }
            }
        }
    }
    
    private func handlePersistantHotkey(event: NSEvent) {
        let currentHotkeys = self.qmkInfoService.hotkeys
        for hotkey in Array(currentHotkeys) {
            if event.keyCode == hotkey.value {
                if !(self.newEntryPanel?.isVisible ?? false) {
                    self.createFloatingPanel(layer: hotkey.key, drawLayout: self.qmkInfoService.currentDrawLayout)
                    self.newEntryPanel.center()
                    self.newEntryPanel.orderFront(nil)
                } else if (self.newEntryPanel?.isVisible ?? false) {
                    self.newEntryPanel?.close()
                    self.newEntryPanel = nil
                }
            }
        }
        
    }
    
}
