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
    var currentLayerShowing: String = ""
    
    var overlayChangeSink: AnyCancellable?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        overlayChangeSink = kfKeyboardStore.$overlayState.sink {
            if $0.layer != self.currentLayerShowing {
                self.newEntryPanel?.close()
                self.newEntryPanel = nil
            }
            if $0.display == true {
                let activeLayout = self.kfKeyboardStore.activeKeyboard?.settings.activeLayout
                self.createFloatingPanel(layer: $0.layer, drawLayout: (self.kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == activeLayout})!)
                self.newEntryPanel.center()
                self.newEntryPanel.orderFront(nil)
            } else {
                self.newEntryPanel?.close()
                self.newEntryPanel = nil
            }
        }
    }
    
    private func createFloatingPanel(layer: String, drawLayout: DrawLayout) {
        let contentView = KeyboardView(maxWidth: drawLayout.keyboardWidth, maxHeight: drawLayout.keyboardHeigt, layer: drawLayout.layers[layer]!).edgesIgnoringSafeArea(.top).padding()
        
        newEntryPanel = FloatingPanel(contentRect: NSRect(x:0, y:0, width: 512, height: 256), backing: .buffered, defer: false)
        newEntryPanel.contentView = NSHostingView(rootView: contentView)
    }
    
}
