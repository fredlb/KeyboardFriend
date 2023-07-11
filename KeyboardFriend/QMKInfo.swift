//
//  QMKInfo.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import Foundation

struct QMKInfo: Codable {
    let keyboards: [String: QMKKeyboard]
}

struct QMKKeyboard: Codable {
    let keyboardName: String
    let keyboardFolder: String
    let layouts: [String: Layout]

    private enum CodingKeys: String, CodingKey {
        case keyboardName = "keyboard_name"
        case keyboardFolder = "keyboard_folder"
        case keymaps, layouts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        keyboardName = try container.decode(String.self, forKey: .keyboardName)
        keyboardFolder = try container.decode(String.self, forKey: .keyboardFolder)

        layouts = try container.decode([String: Layout].self, forKey: .layouts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keyboardName, forKey: .keyboardName)
        try container.encode(keyboardFolder, forKey: .keyboardFolder)
        
        try container.encode(layouts, forKey: .layouts)
    }
}

struct Layout: Codable {
    let layout: [MatrixEntry]
}

struct MatrixEntry: Codable, Hashable {
    let matrix: [Int]
    let x: Float
    let y: Float
    let w: Float?
}

struct DrawEntry: Hashable {
    let matrix: [Int]
    let x: Double
    let y: Double
    let w: Double
    let text: String
}

struct QMKKeymap: Codable {
    let keyboard: String
    let keymap: String
    let layout: String
    let layers: [[String]]
}

struct DrawLayout {
    let keyboardWidth: Double
    let keyboardHeigt: Double
    let layers: [String:[DrawEntry]]
}

struct DrawSingleLayout {
    let keyboardWidth: Double
    let keyboardHeigt: Double
    let layout: [DrawEntry]
}

struct QMKKeycodeMap {
    static let map: [String: String] = [
        // QMK keycodes
        "XXXXXXX": "",
        "NO": "",
        "MINUS": "-",
        "MINS": "-",
        "EQUAL": "=",
        "EQL": "=",
        "LEFT_BRACKET": "[",
        "LBRC": "[",
        "RIGHT_BRACKET": "]",
        "RBRC": "]",
        "BACKSLASH": "\\",
        "BSLS": "\\",
        "NONUS_HASH": "#",
        "NUHS": "#",
        "SEMICOLON": ";",
        "SCLN": ";",
        "QUOTE": "'",
        "QUOT": "'",
        "GRAVE": "`",
        "GRV": "`",
        "COMMA": ",",
        "COMM": ",",
        "DOT": ".",
        "SLASH": "/",
        "SLSH": "/",
        "TILDE": "~",
        "TILD": "~",
        "EXCLAIM": "!",
        "EXLM": "!",
        "AT": "@",
        "HASH": "#",
        "DOLLAR": "$",
        "DLR": "$",
        "PERCENT": "%",
        "PERC": "%",
        "CIRCUMFLEX": "^",
        "CIRC": "^",
        "AMPERSAND": "&",
        "AMPR": "&",
        "ASTERISK": "*",
        "ASTR": "*",
        "LEFT_PAREN": "(",
        "LPRN": "(",
        "RIGHT_PAREN": ")",
        "RPRN": ")",
        "UNDERSCORE": "_",
        "UNDS": "_",
        "PLUS": "+",
        "LEFT_CURLY_BRACE": "{",
        "LCBR": "{",
        "RIGHT_CURLY_BRACE": "}",
        "RCBR": "}",
        "PIPE": "|",
        "COLON": ":",
        "COLN": ":",
        "DOUBLE_QUOTE": "\"",
        "DQUO": "\"",
        "DQT": "\"",
        "LEFT_ANGLE_BRACKET": "<",
        "LABK": "<",
        "LT": "<",
        "RIGHT_ANGLE_BRACKET": ">",
        "RABK": ">",
        "GT": ">",
        "QUESTION": "?",
        "QUES": "?",
        "LEFT": "←",
        "DOWN": "↓",
        "UP": "↑",
        "RGHT": "→",
        
    ]
    
    static func convertQMKKeycode(_ keycode: String) -> String {
        let strippedKeycode = keycode.deletingPrefix("KC_")
        if strippedKeycode == "TRNS" {
            return "▽"
        }
        return map[strippedKeycode] ?? strippedKeycode
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

struct SimpleKeyboard {
    let keyboardName: String
    let dimensions: PhysicalDimensions
    let layouts: [String: Layout]
    let layers: [String:[DrawEntry]]
}

struct PhysicalDimensions {
    let width: Double
    let height: Double
}
