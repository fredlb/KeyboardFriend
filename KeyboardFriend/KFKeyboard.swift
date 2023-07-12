//
//  KFKeyboard.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-12.
//

import Foundation

struct KFKeyboard: Decodable, Encodable {
    let name: String
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

class KFKeyboardStore : ObservableObject {
    static let shared = KFKeyboardStore()
    @Published var activeKeyboard: KFKeyboard?
    
    private static func fileURL(keyboardName: String) throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("\(keyboardName).data")
    }
    
    func load(fileURL: URL) async throws {
        let task = Task<KFKeyboard?, Error> {
//            let fileURL = try Self.fileURL(keyboardName: "")
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            let keyboard = try JSONDecoder().decode(KFKeyboard.self, from: data)
            return keyboard
        }
        
        let activeKeyboard = try await task.value
        self.activeKeyboard = activeKeyboard
    }
    
    func save(keyboard: KFKeyboard) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(keyboard)
            let outfile = try Self.fileURL(keyboardName: keyboard.name)
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
