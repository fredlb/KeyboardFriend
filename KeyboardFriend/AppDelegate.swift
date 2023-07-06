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
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 111 { // F16 Key
                if !(self.newEntryPanel?.isVisible ?? false) {
                    self.createFloatingPanel(drawLayout: self.qmkInfoService.currentDrawLayout)
                    self.newEntryPanel.center()
                    self.newEntryPanel.orderFront(nil)
                }
            }
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { event in
            if event.keyCode == 111 { // F16 Key
                self.newEntryPanel?.close()
            }
        }
    }
    
    private func createFloatingPanel(drawLayout: DrawLayout) {
        let contentView = KeyboardView(maxWidth: drawLayout.keyboardWidth, maxHeight: drawLayout.keyboardHeigt, layer: drawLayout.layers["L0"]!).edgesIgnoringSafeArea(.top).padding()
        
        newEntryPanel = FloatingPanel(contentRect: NSRect(x:0, y:0, width: 512, height: 256), backing: .buffered, defer: false)
        newEntryPanel.title = "Floaty boi"
        newEntryPanel.contentView = NSHostingView(rootView: contentView)
    }
}
