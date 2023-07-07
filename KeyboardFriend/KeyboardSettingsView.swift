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
    @EnvironmentObject var qmkInfoService: QMKInfoService
    @State var hotkeySelection: String = ""
    private let hotkeys:[String:Int] = ["F16":106, "F17":64, "F18": 79, "F19": 80, "F20": 90]
    
    var body: some View {
        VStack {
            HStack {
                Picker("Keyboard shortcut", selection: $hotkeySelection) {
                    hotKeyPickerContent()
                }
                .onChange(of: hotkeySelection) { _ in qmkInfoService.setHotkeyForLayer(layer: layerName, keyCode: hotkeys[hotkeySelection]!)}
                .frame(maxWidth: 200)
                Spacer()
            }
            
            KeyboardView(maxWidth: qmkInfoService.currentDrawLayout.keyboardWidth, maxHeight: qmkInfoService.currentDrawLayout.keyboardHeigt, layer: layer)
        }
    }
    
    @ViewBuilder
    func hotKeyPickerContent() -> some View {
        ForEach(Array(hotkeys), id: \.key) {
            Text($0.key)
        }
    }
}

struct KeyboardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardSettingsView(layer: [], layerName: "Test").environmentObject(QMKInfoService())
    }
}
