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
    var shortcuts: [String:String?]
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

class InMemoryStorageProvider: StorageProvider {
    
    private var storage: [String:String?] = [:]
    
    func set(_ value: String?, forKey defaultName: String) {
        self.storage.updateValue(value, forKey: defaultName)
    }

    func remove(forKey defaultName: String) {
        self.storage.removeValue(forKey: defaultName)
    }

    func get(forKey defaultName: String) -> String? {
        guard let data = self.storage[defaultName] else {
            return nil
        }
        return data
    }
    
    func getAll() -> [String: String?] {
        return storage
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
            var clonedKeyboard = keyboard
            for (name, shortcut) in self.shortcutStorage.getAll() {
                clonedKeyboard.shortcuts.updateValue(shortcut, forKey: name)
            }
            let data = try JSONEncoder().encode(clonedKeyboard)
            let outfile = try Self.fileURL(keyboardName: clonedKeyboard.name)
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    func setActiveLayout(layout: String) {
        self.activeKeyboard?.settings.activeLayout = layout
    }
    
    func saveActiveKeyboard(fileURL: URL) async throws {
        let task = Task {
            var clonedKeyboard = activeKeyboard
            for (name, shortcut) in self.shortcutStorage.getAll() {
                clonedKeyboard!.shortcuts.updateValue(shortcut, forKey: name)
            }
            let data = try JSONEncoder().encode(clonedKeyboard!)
            try data.write(to: fileURL)
        }
        _ = try await task.value
    }
    
    func setupListener(layer: String) {
        KeyboardShortcuts.onKeyUp(for: KeyboardShortcuts.Name(layer, customStorageProvider: shortcutStorage)) { [self] in
            if overlayState.layer == layer {
                self.overlayState.display.toggle()
            } else {
                self.overlayState.layer = layer
                self.overlayState.display = true
            }
        }
    }
    
}
