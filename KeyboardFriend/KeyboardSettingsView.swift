//
//  KeyboardSettingsView.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-07.
//

import SwiftUI

struct KeyboardSettingsView: View {
    let layer: [DrawEntry]
    let layerName: String
    let maxWidth: Double
    let maxHeight: Double
    @State var hotkeySelection: String = ""
    private let hotkeys:[String:Int] = ["F16":106, "F17":64, "F18": 79, "F19": 80, "F20": 90]
    
    var body: some View {
        VStack {
            HStack {
                Picker("Keyboard shortcut", selection: $hotkeySelection) {
                    ForEach(Array(hotkeys), id: \.key) {
                        Text($0.key)
                    }
                    .onChange(of: hotkeySelection) { _ in }
                    .frame(maxWidth: 200)
                    Spacer()
                }
                
                KeyboardView(maxWidth: maxWidth, maxHeight: maxHeight, layer: layer)
            }
        }
    }
}

struct KeyboardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardSettingsView(layer: [], layerName: "Test", maxWidth: 0, maxHeight: 0)
    }
}
