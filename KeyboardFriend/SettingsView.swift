//
//  LayersView.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import SwiftUI



struct SettingsView: View {
    @EnvironmentObject var qmkInfoService: QMKInfoService
    @StateObject var kfKeyboardStore: KFKeyboardStore = KFKeyboardStore.shared
    
    @State var hotkeySetting = [String:Int]()
    @State var layoutSelection: String?
    @State var hotkeySelection: String = ""
    @State private var started: Bool = false
    private let hotkeys:[String:Int] = ["F13":111, "F14":112, "F15": 113, "F16": 114, "F17": 115]
    @State var holdHotkey: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Button("Load QMK keymap"){
                    let openPanel = NSOpenPanel()
                    openPanel.canChooseFiles = true
                    openPanel.canChooseDirectories = false
                    openPanel.allowsMultipleSelection = false
                    openPanel.allowedContentTypes = [.json]
                    
                    openPanel.begin { response in
                        guard response == .OK, let fileURL = openPanel.urls.first else { return }
                        
                        do {
                            let jsonData = try Data(contentsOf: fileURL)
                            let decoder = JSONDecoder()
                            let keymap = try decoder.decode(QMKKeymap.self, from: jsonData)
                            Task {
                                try? await qmkInfoService.generateKFKeyboardFromQMKKeymap(keymap: keymap)
                            }
                        } catch {
                            print("Error loading JSON: \(error)")
                        }
                    }
                }
                Button("Load configuration") {
                    let openPanel = NSOpenPanel()
                    openPanel.canChooseFiles = true
                    openPanel.canChooseDirectories = false
                    openPanel.allowsMultipleSelection = false
                    openPanel.allowedContentTypes = [.data]
                    
                    openPanel.begin { response in
                        guard response == .OK, let fileURL = openPanel.urls.first else { return }
                        
                        Task {
                            try? await kfKeyboardStore.load(fileURL: fileURL)
                        }
                    }
                }
                Spacer()
                Picker("Layout", selection: $layoutSelection) {
                    Text("None").tag(nil as String?)
                    ForEach(kfKeyboardStore.activeKeyboard?.drawLayouts ?? [], id: \.name) {
                        Text($0.name).tag($0.name as String?)
                    }
                }
                .frame(maxWidth: 200)
                .pickerStyle(MenuPickerStyle())
                
                Toggle(isOn: $holdHotkey) {
                    Text("Hold")
                }
                .onChange(of: holdHotkey) { _ in
                    qmkInfoService.holdHotkey.toggle()
                }
                .toggleStyle(.checkbox)
            }
            Divider()
            VStack {
                if kfKeyboardStore.activeKeyboard == nil {
                    Text("Load a QMK JSON config to get started, or load an already existing configuration")
                } else if layoutSelection != nil{
                    TabView {
                        ForEach((kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == layoutSelection}!.layers.sorted(by: {$0.key < $1.key}))!, id: \.key) {
                            layerName, layer in
                            KeyboardSettingsView(layer: layer, layerName: layerName, maxWidth: (kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == layoutSelection}!.keyboardWidth)!, maxHeight: (kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == layoutSelection}!.keyboardHeigt)!)
                                .tabItem{Text("Layer \(layerName)")}
                        }
//                        ForEach(qmkInfoService.currentDrawLayout.layers.sorted(by: {$0.key < $1.key}), id: \.key) {
//                            layerName, layer in
//                            KeyboardSettingsView(layer: layer, layerName: layerName)
//                                .tabItem{Text("Layer \(layerName)")}
//                        }
                    }
                }
            }.frame(maxHeight: .infinity)
        }
        .padding()
//        .onFirstAppear() {
//            print("firstAppear")
//            let defaults = UserDefaults.standard
//            let lastUsedKeyboardFile = defaults.string(forKey: "keyboardFile")
//            if lastUsedKeyboardFile != nil {
//                do {
//                    let jsonData = try Data(contentsOf: URL(string: lastUsedKeyboardFile!)!)
//                    let decoder = JSONDecoder()
//                    let keymap = try decoder.decode(QMKKeymap.self, from: jsonData)
//                    Task {
//                        try? await qmkInfoService.fetchQMKInfo(keymap: keymap)
//                    }
//                } catch {
//                    print("Error loading JSON: \(error)")
//                }
//            }
//        }
    }
    
    @ViewBuilder
    func pickerContent() -> some View {
        ForEach(kfKeyboardStore.activeKeyboard?.drawLayouts ?? [], id: \.self) {
            Text($0.name)
        }
    }
    
    @ViewBuilder
    func hotKeyPickerContent() -> some View {
        ForEach(Array(hotkeys), id: \.key) {
            Text($0.key)
        }
    }
}

public extension View {
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }
}

private struct FirstAppear: ViewModifier {
    let action: () -> ()
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(kfKeyboardStore: KFKeyboardStore()).environmentObject({ () -> QMKInfoService in
            let envObj = QMKInfoService()
            envObj.currentDrawLayout = DrawLayout(keyboardWidth: Double(14), keyboardHeigt: Double(4), name: "", layers: ["L2": []])
            return envObj
        }() )
    }
    
    
}
