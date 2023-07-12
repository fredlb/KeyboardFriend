//
//  QMKInfoService.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import Foundation

class QMKInfoService: ObservableObject {
    
    @Published var currentDrawLayout: DrawLayout = DrawLayout(keyboardWidth: 0.0, keyboardHeigt: 0.0, name: "", layers: ["":[]])
    @Published var layouts: [String] = []
    @Published var hotkeys: [String:Int] = [:]
    @Published var holdHotkey: Bool = false
    var kfStore = KFKeyboardStore.shared
    
//    var kfKeyboardStore: KFKeyboardStore = KFKeyboardStore()
    
    var qmkInfo: QMKInfo?
    var currentKeymap: QMKKeymap?
    
    func fetchQMKInfo(keymap: QMKKeymap) async throws {
        self.currentKeymap = keymap
        let data = try await self.fetchFromLocalOrRemote(keyboard: keymap.keyboard)
        
        Task { @MainActor in
            self.qmkInfo = try JSONDecoder().decode(QMKInfo.self, from: data!)
            let qmkInfoFirstLayout = self.qmkInfo!.keyboards[keymap.keyboard]!.layouts.first!.key
            self.layouts = Array(self.qmkInfo!.keyboards[keymap.keyboard]!.layouts.keys)
            self.currentDrawLayout = generateDrawConfig(layoutKey: qmkInfoFirstLayout, qmkInfo: self.qmkInfo!, keymap: keymap)
        }
    }
    
    func generateKFKeyboardFromQMKKeymap(keymap: QMKKeymap) async throws {
        let data = try await self.fetchFromLocalOrRemote(keyboard: keymap.keyboard)
        
        Task { @MainActor in
            let qmkInfo = try JSONDecoder().decode(QMKInfo.self, from: data!)
            let layouts = Array(qmkInfo.keyboards[keymap.keyboard]!.layouts.keys)
            var allDrawLayouts = [DrawLayout]()
            for layout in layouts {
                allDrawLayouts.append(generateDrawConfig(layoutKey: layout, qmkInfo: qmkInfo, keymap: keymap))
            }
            let keyboardName = keymap.keyboard.replacingOccurrences(of: "/", with: "-")
            self.kfStore.activeKeyboard = KFKeyboard(name: keyboardName, drawLayouts: allDrawLayouts, settings: KFSettings(activeLayout: layouts.first!, hold: false, hotkeys: [Hotkey(key: "F16", keycode: 111)]))
            print("activeKeyboard set")
        }
    }
    
    func changeDrawConfigForLayout(layoutKey: String) {
        self.currentDrawLayout = generateDrawConfig(layoutKey: layoutKey, qmkInfo: self.qmkInfo!, keymap: self.currentKeymap!)
    }
    
    private func generateDrawConfig(layoutKey: String, qmkInfo: QMKInfo, keymap: QMKKeymap) -> DrawLayout {
        let layout = qmkInfo.keyboards[keymap.keyboard]!.layouts[layoutKey]!.layout
        
        var allLayers = [String: [DrawEntry]]()
        var maxWidth = Float(0.0)
        var maxHeight = Float(0.0)
        
        for (index, layer) in keymap.layers.enumerated() {
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
        
        return DrawLayout(keyboardWidth: Double(maxWidth), keyboardHeigt: Double(maxHeight), name: layoutKey, layers: allLayers)
    }
    
    func setHotkeyForLayer(layer: String, keyCode: Int) {
        self.hotkeys.updateValue(keyCode, forKey: layer)
    }
    
    func fetchFromLocalOrRemote(keyboard: String) async throws -> Data? {
        let url = "https://keyboards.qmk.fm/v1/keyboards/\(keyboard)/info.json"
        let keyboardFile = keyboard.replacingOccurrences(of: "/", with: "-")
        let fileIO = FileIOController()
        let data = try fileIO.loadJSON(withFilename: keyboardFile)
        if (data == nil) {
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            try fileIO.write(data, toDocumentNamed: "\(keyboardFile).json")
            return data
        } else {
            return data
        }
    }
}

struct FileIOController {
    var manager = FileManager.default

    func write(
        _ object: Data,
        toDocumentNamed documentName: String
    ) throws {
        let rootFolderURL = try manager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let nestedFolderURL = rootFolderURL.appendingPathComponent("KeyboardFriend")

        do {
            try manager.createDirectory(
                at: nestedFolderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        } catch CocoaError.fileWriteFileExists {
            // Folder already existed
        } catch {
            throw error
        }

        let fileURL = nestedFolderURL.appendingPathComponent(documentName)
        try object.write(to: fileURL)
    }
    
    func loadJSON(withFilename filename: String) throws -> Data? {
        let rootFolderURL = try manager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let nestedFolderURL = rootFolderURL.appendingPathComponent("KeyboardFriend")
    
        var fileURL = nestedFolderURL.appendingPathComponent(filename)
        fileURL = fileURL.appendingPathExtension("json")
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            return nil
        }
    }
}
