//
//  KeyboardSettingsView.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-07.
//

import SwiftUI
import KeyboardShortcuts


struct KeyboardSettingsView: View {
    let kfKeyboardStore: KFKeyboardStore
    let layer: [DrawEntry]
    let layerName: String
    let maxWidth: Double
    let maxHeight: Double
    @State var hotkeySelection: Hotkey?
    private let hotkeys:[Hotkey] = [Hotkey(key: "F16", keycode: 106),Hotkey(key: "F17", keycode: 64)]
    
    
    var body: some View {
        VStack {
            KeyboardView(maxWidth: maxWidth, maxHeight: maxHeight, layer: layer)
            HStack {
            }
        }        
    }
    
}

struct KeyboardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardSettingsView(kfKeyboardStore: KFKeyboardStore(), layer: [], layerName: "Test", maxWidth: 0, maxHeight: 0)
    }
}
