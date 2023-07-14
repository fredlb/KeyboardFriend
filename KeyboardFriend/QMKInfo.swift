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
    let h: Float?
}

struct DrawEntry: Decodable, Hashable, Encodable {
    let matrix: [Int]
    let x: Double
    let y: Double
    let w: Double
    let h: Double
    let text: String
}

struct QMKKeymap: Codable {
    let keyboard: String
    let keymap: String
    let layout: String
    let layers: [[String]]
}

struct DrawLayout: Decodable, Encodable, Hashable {
    let keyboardWidth: Double
    let keyboardHeigt: Double
    let name: String
    let layers: [String:[DrawEntry]]
}

struct DrawSingleLayout {
    let keyboardWidth: Double
    let keyboardHeigt: Double
    let layout: [DrawEntry]
}


enum LabelType : Encodable, Decodable {
    case Text
    case LayerSymbol
}

struct Label {
    let content: String
    let type: LabelType
    let layerText: String?
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
    
    static let layerPrefixes = ["MO", "TG", "TO", "TT", "DF", "OSL"]
    
    static let glyphsMap: [String:String] = [
        "LGUI": "command",
        "RGUI": "command",
        "SPC": "space",
        "LCTL": "control",
        "RCTRL": "control",
        "LALT": "option",
        "RALT": "alt",
        "LSFT": "shift",
        "BSPC": "delete.backward",
        "DEL": "delete.forward",
        "TAB": "arrow.right.to.line.compact",
        "ENT": "return"
    ]
    
    static func getGlyph(_ keycode: String) -> String? {
        if let glyph = glyphsMap[keycode] {
            return glyph
        }
        return nil
    }
    
    static func convertQMKKeycode(_ keycode: String) -> String {
        let strippedKeycode = keycode.deletingPrefix("KC_")
        if strippedKeycode == "TRNS" {
            return "▽"
        }
        return map[strippedKeycode] ?? strippedKeycode
    }
    
    static func getLabelForQMKKeycode(_ keycode: String) -> Label {
        let strippedKeycode = keycode.deletingPrefix("KC_")
        if strippedKeycode == "TRNS" {
            return Label(content: "▽", type: .Text, layerText: nil)
        }
        if layerPrefixes.contains(where: strippedKeycode.hasPrefix) {
            let (number, text) = extractNumberAndText(from: strippedKeycode)!
            return Label(content: number, type: .LayerSymbol, layerText: text)
        }
        return Label(content: map[strippedKeycode] ?? strippedKeycode, type: .Text, layerText: nil)
    }
    
    static func extractNumber(from inputString: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: "\\((\\d{1,2})\\)", options: [])
            let range = NSRange(location: 0, length: inputString.utf16.count)
            
            if let match = regex.firstMatch(in: inputString, options: [], range: range) {
                let numberRange = match.range(at: 1)
                if let extractedRange = Range(numberRange, in: inputString) {
                    let extractedNumber = inputString[extractedRange]
                    
                    if let number = Int(extractedNumber), number >= 0 && number <= 99 {
                        return String(number)
                    }
                }
            }
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
    
    static func extractNumberAndText(from inputString: String) -> (number: String, text: String)? {
        do {
            let regex = try NSRegularExpression(pattern: "([A-Z]+)\\((\\d{1,2})\\)", options: [])
            let range = NSRange(location: 0, length: inputString.utf16.count)
            
            if let match = regex.firstMatch(in: inputString, options: [], range: range) {
                let textRange = match.range(at: 1)
                let numberRange = match.range(at: 2)
                
                if let extractedTextRange = Range(textRange, in: inputString),
                   let extractedNumberRange = Range(numberRange, in: inputString) {
                    let extractedText = inputString[extractedTextRange]
                    let extractedNumber = inputString[extractedNumberRange]
                    
                    if let number = Int(extractedNumber), number >= 0 && number <= 99 {
                        return (number: String(number), text: String(extractedText))
                    }
                }
            }
        } catch {
            print("Error: \(error)")
        }
        
        return nil
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
