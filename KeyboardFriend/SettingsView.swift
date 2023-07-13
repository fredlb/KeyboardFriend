//
//  LayersView.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import SwiftUI



struct SettingsView: View {
    @EnvironmentObject var qmkInfoService: QMKInfoService
    @EnvironmentObject var kfKeyboardStore: KFKeyboardStore
    
    @State var hotkeySetting = [String:Int]()
    @State var layoutSelection: String = ""
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
                                let result = try? await qmkInfoService.generateKFKeyboardFromQMKKeymap(keymap: keymap)
                                let keyboard = try result?.get()
                                kfKeyboardStore.activeKeyboard = keyboard
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
                            let keeb = try? await kfKeyboardStore.load(fileURL: fileURL)
                            kfKeyboardStore.activeKeyboard = keeb
                        }
                    }
                }
                Button("Save configuration") {
                    let savePanel = NSSavePanel()
                    savePanel.canCreateDirectories = true
                    savePanel.isExtensionHidden = false
                    savePanel.allowsOtherFileTypes = false
                    savePanel.title = "Save your current keyboard configuration"
                    savePanel.message = "Choose a folder and a name to store keyboard configuration."
                    savePanel.nameFieldLabel = "File name:"
                    
                    savePanel.begin { response in
                        guard response == .OK, let fileURL = savePanel.url else { return }
                        
                        Task {
                            try? await kfKeyboardStore.saveActiveKeyboard(fileURL: fileURL)
                        }
                    }
                }.disabled(kfKeyboardStore.activeKeyboard == nil)
                Spacer()
                Picker("Layout", selection: $layoutSelection) {
                    ForEach(kfKeyboardStore.activeKeyboard?.drawLayouts ?? [], id: \.name) {
                        Text($0.name).tag($0.name)
                    }
                }
                .onChange(of: layoutSelection) { _ in
                    kfKeyboardStore.setActiveLayout(layout: layoutSelection)
                }
                .onReceive(kfKeyboardStore.$activeKeyboard) {
                    self.layoutSelection = $0?.settings.activeLayout ?? ""
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
                } else if layoutSelection != ""{
                    TabView {
                        ForEach((kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == kfKeyboardStore.activeKeyboard?.settings.activeLayout}!.layers.sorted(by: {$0.key < $1.key}))!, id: \.key) {
                            layerName, layer in
                            KeyboardSettingsView(layer: layer, layerName: layerName, maxWidth: (kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == layoutSelection}!.keyboardWidth)!, maxHeight: (kfKeyboardStore.activeKeyboard?.drawLayouts.first {$0.name == layoutSelection}!.keyboardHeigt)!).environmentObject(kfKeyboardStore)
                                .tabItem{Text("Layer \(layerName)")}
                        }
                    }
                } else {
                    Text("Pick a layout")
                }
            }.frame(maxHeight: .infinity)
        }
        .padding()
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
        SettingsView().environmentObject({ () -> QMKInfoService in
            let envObj = QMKInfoService()
            envObj.currentDrawLayout = DrawLayout(keyboardWidth: Double(14), keyboardHeigt: Double(4), name: "", layers: ["L2": []])
            return envObj
        }() )
        .environmentObject({ () -> KFKeyboardStore in
            let envObj = KFKeyboardStore()
            return envObj
        }() )

    }
    
    
}
