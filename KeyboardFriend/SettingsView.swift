//
//  LayersView.swift
//  KeebDrawTest
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import SwiftUI



struct SettingsView: View {
    @EnvironmentObject var qmkInfoService: QMKInfoService
    @State var hotkeySetting = [String:Int]()
    @State var layoutSelection: String = ""
    @State var hotkeySelection: String = ""
    private let hotkeys:[String:Int] = ["F13":111, "F14":112, "F15": 113, "F16": 114, "F17": 115]
    
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
                                try? await qmkInfoService.fetchQMKInfo(keymap: keymap)
                            }
                        } catch {
                            print("Error loading JSON: \(error)")
                        }
                    }
                }
                Spacer()
                Picker("Layout", selection: $layoutSelection) {
                    pickerContent()
                }
                .onChange(of: layoutSelection) { _ in
                    qmkInfoService.changeDrawConfigForLayout(layoutKey: layoutSelection)
                }
                .onReceive(qmkInfoService.$layouts) {
                    self.layoutSelection = $0.first ?? ""
                }
                .frame(maxWidth: 200)
                .disabled(qmkInfoService.qmkInfo == nil)
                .pickerStyle(MenuPickerStyle())
            }
            Divider()
            VStack {
                TabView {
                    ForEach(qmkInfoService.currentDrawLayout.layers.sorted(by: {$0.key < $1.key}), id: \.key) {
                        layerName, layer in
                        KeyboardSettingsView(layer: layer, layerName: layerName)
                        .tabItem{Text("Layer \(layerName)")}
                    }
                }
            }.frame(maxHeight: .infinity)
        }.padding()
    }
    
    @ViewBuilder
    func pickerContent() -> some View {
        ForEach(qmkInfoService.layouts, id: \.self) {
            Text($0)
        }
    }
    
    @ViewBuilder
    func hotKeyPickerContent() -> some View {
        ForEach(Array(hotkeys), id: \.key) {
            Text($0.key)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject({ () -> QMKInfoService in
            let envObj = QMKInfoService()
            envObj.currentDrawLayout = DrawLayout(keyboardWidth: Double(14), keyboardHeigt: Double(4), layers: ["L2": []])
            return envObj
        }() )
    }
    
    
}
