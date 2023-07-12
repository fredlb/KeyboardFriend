//
//  KeyboardSettingsView.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-07.
//

import SwiftUI

struct KeyboardSettingsView: View {
    @EnvironmentObject var kfKeyboardStore: KFKeyboardStore
    
    let layer: [DrawEntry]
    let layerName: String
    let maxWidth: Double
    let maxHeight: Double
    @State var hotkeySelection: Hotkey?
    private let hotkeys:[Hotkey] = [Hotkey(key: "F16", keycode: 106),Hotkey(key: "F17", keycode: 64)]
    
    var body: some View {
        VStack {
            HStack {
                
                Picker("Keyboard shortcut", selection: $hotkeySelection) {
                    Text("None").tag(nil as Hotkey?)
                    ForEach(hotkeys, id: \.keycode) {
                        Text($0.key).tag($0 as Hotkey?)
                    }
                    .onChange(of: hotkeySelection ?? Hotkey(key: "None", keycode: 0)) { newValue in
                        kfKeyboardStore.activeKeyboard?.settings.hotkeys[layerName] = newValue
                    }
                    .frame(maxWidth: 200)
                }
                Spacer()
                
            }
            KeyboardView(maxWidth: maxWidth, maxHeight: maxHeight, layer: layer)
        }
    }
}

struct KeyboardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardSettingsView(layer: [], layerName: "Test", maxWidth: 0, maxHeight: 0)
    }
}
