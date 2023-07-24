//
//  KFKeyboard.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-12.
//

import Foundation
import KeyboardShortcuts

struct KFKeyboard: Decodable, Encodable {
    let name: String
    let uuid: UUID
    let drawLayouts: [DrawLayout]
    var settings: KFSettings
}

struct KFSettings: Decodable, Encodable {
    var activeLayout: String
    var hold: Bool
    var hotkeys: [String:Hotkey]
}

struct Hotkey: Decodable, Encodable, Hashable {
    let key: String
    let keycode: Int
}

struct InMemoryStorageProvider: StorageProvider {
    
    private var storage: [String:KeyboardShortcuts.Shortcut?] = [:]
    
    mutating func set(_ value: KeyboardShortcuts.Shortcut?, forKey defaultName: String) {
        self.storage.updateValue(value, forKey: defaultName)
    }

    mutating func remove(forKey defaultName: String) {
        self.storage.removeValue(forKey: defaultName)
    }

    func get(forKey defaultName: String) -> KeyboardShortcuts.Shortcut? {
        guard let data = self.storage[defaultName] else {
            return nil
        }
        return data
    }
    
    func getAll() -> [String: KeyboardShortcuts.Shortcut?] {
        return self.storage
    }
    
}

struct OverlayState {
    public var layer: String = ""
    public var display: Bool = false
}

class KFKeyboardStore : ObservableObject {
    @Published var activeKeyboard: KFKeyboard?
    @Published var showOverlay: Bool = false
    @Published var overLayChanged: UUID = UUID()
    @Published var overlayLayer: String = ""
    @Published var overlayState: OverlayState = OverlayState()
    @Published var shortcutStorage: InMemoryStorageProvider = InMemoryStorageProvider()
    
    private static func fileURL(keyboardName: String) throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("\(keyboardName).data")
    }
    
    func load(fileURL: URL) async throws -> KFKeyboard? {
        let task = Task<KFKeyboard?, Error> {
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            let keyboard = try JSONDecoder().decode(KFKeyboard.self, from: data)
            return keyboard
        }
        
        let loadedKeyboard = try await task.value
        return loadedKeyboard
    }
    
    func save(keyboard: KFKeyboard) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(keyboard)
            let outfile = try Self.fileURL(keyboardName: keyboard.name)
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    func setActiveLayout(layout: String) {
        self.activeKeyboard?.settings.activeLayout = layout
    }
    
    func saveActiveKeyboard(fileURL: URL) async throws {
        let task = Task {
            print("save \(self.shortcutStorage.getAll())")
            let data = try JSONEncoder().encode(activeKeyboard!)
            try data.write(to: fileURL)
        }
        _ = try await task.value
    }
    
    func setupListener(layer: String) {
        KeyboardShortcuts.onKeyUp(for: KeyboardShortcuts.Name(layer, customStorageProvider: shortcutStorage)) { [self] in
            print(overlayState.layer, layer)
            if overlayState.layer == layer {
                self.overlayState.display.toggle()
            } else {
                self.overlayState.layer = layer
                self.overlayState.display = true
            }
        }
    }
    
}
