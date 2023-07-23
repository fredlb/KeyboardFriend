//
//  KeyboardViewNew.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-15.
//

import SwiftUI
import KeyboardShortcuts

struct Shortcut: Hashable, Identifiable {
    var id: String
    var name: KeyboardShortcuts.Name
}

struct LayerSettingsView: View {
    let kfKeyboardStore: KFKeyboardStore
    
    let layer: [DrawEntry]
    let layerName: String
    let maxWidth: Double
    let maxHeight: Double
    
    var body: some View {
        VStack {
            KeyboardView(maxWidth: maxWidth, maxHeight: maxHeight, layer: layer)
            HStack {
                KeyboardShortcuts.Recorder(for: KeyboardShortcuts.Name(layerName, customStorageProvider: kfKeyboardStore.shortcutStorage)) { shortcut in
                    kfKeyboardStore.setupListener(layer: layerName)
                }
            }
        }
    }
}

struct LayerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LayerSettingsView(kfKeyboardStore: KFKeyboardStore(), layer: [], layerName: "Test", maxWidth: 0, maxHeight: 0)
    }
}
