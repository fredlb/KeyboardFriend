//
//  QMKInfoService.swift
//  KeebDrawTest
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import Foundation

class QMKInfoService: ObservableObject {
    
    @Published var currentDrawLayout: DrawLayout = DrawLayout(keyboardWidth: 0.0, keyboardHeigt: 0.0, layers: ["":[]])
    @Published var layouts: [String] = []
    @Published var hotkeys: [String:Int] = [:]
    
    var qmkInfo: QMKInfo?
    var currentKeymap: QMKKeymap?
    
    func fetchQMKInfo(keymap: QMKKeymap) async throws {
        self.currentKeymap = keymap
        let url = "https://keyboards.qmk.fm/v1/keyboards/\(keymap.keyboard)/info.json"
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        
        Task { @MainActor in
            self.qmkInfo = try JSONDecoder().decode(QMKInfo.self, from: data)
            let qmkInfoFirstLayout = self.qmkInfo!.keyboards[keymap.keyboard]!.layouts.first!.key
            self.layouts = Array(self.qmkInfo!.keyboards[keymap.keyboard]!.layouts.keys)
            self.currentDrawLayout = generateDrawConfig(layoutKey: qmkInfoFirstLayout)
        }
    }
    
    func changeDrawConfigForLayout(layoutKey: String) {
        self.currentDrawLayout = generateDrawConfig(layoutKey: layoutKey)
    }
    
    private func generateDrawConfig(layoutKey: String) -> DrawLayout {
        let layout = self.qmkInfo!.keyboards[self.currentKeymap!.keyboard]!.layouts[layoutKey]!.layout
        
        var allLayers = [String: [DrawEntry]]()
        var maxWidth = Float(0.0)
        var maxHeight = Float(0.0)
        
        for (index, layer) in self.currentKeymap!.layers.enumerated() {
            var drawLayoutTemp: [DrawEntry] = []
            
            for (index, matrixEntry) in layout.enumerated() {
                
                drawLayoutTemp.append(DrawEntry(matrix: matrixEntry.matrix, x: Double(matrixEntry.x), y: Double(matrixEntry.y), w: Double(matrixEntry.w ?? 1), text: layer[index]))
                if matrixEntry.x > maxWidth {
                    maxWidth = matrixEntry.x
                }
                if matrixEntry.y > maxHeight {
                    maxHeight = matrixEntry.y
                }
            }
            allLayers["L\(index)"] = drawLayoutTemp
        }
        
        return DrawLayout(keyboardWidth: Double(maxWidth), keyboardHeigt: Double(maxHeight), layers: allLayers)
    }
    
    func setHotkeyForLayer(layer: String, keyCode: Int) {
        self.hotkeys.updateValue(keyCode, forKey: layer)
        print(self.hotkeys)
        
    }
}
