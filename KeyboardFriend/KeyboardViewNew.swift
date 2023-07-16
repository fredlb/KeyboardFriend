//
//  KeyboardViewNew.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-15.
//

import SwiftUI
import KeyboardShortcuts


extension KeyboardShortcuts.Name {
    static let testShortcut1 = Self("testShortcut1")
    static let testShortcut2 = Self("testShortcut2")
    static let testShortcut3 = Self("testShortcut3")
    static let testShortcut4 = Self("testShortcut4")
}

private struct DynamicShortcutRecorder: View {
    @FocusState private var isFocused: Bool
    
    @Binding var name: KeyboardShortcuts.Name
    @Binding var isPressed: Bool
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            KeyboardShortcuts.Recorder(for: name)
                .focused($isFocused)
                .padding(.trailing, 10)
            Text("Pressed? \(isPressed ? "👍" : "👎")")
                .frame(width: 100, alignment: .leading)
        }
        .onChange(of: name) { _ in
            isFocused = true
        }
    }
}

struct Shortcut: Hashable, Identifiable {
    var id: String
    var name: KeyboardShortcuts.Name
}

struct KeyboardViewNew: View {
    let kfKeyboardStore: KFKeyboardStore
    
    @State var kfName2: Shortcut
    
    var body: some View {
        VStack {
            HStack {
                KeyboardShortcuts.Recorder(for: self.kfName2.name) { shortcut in
//                    kfKeyboardStore.shortcuts[kfName2.id] = kfName2
                    print("New shortcut")
                    print(shortcut)
                    kfKeyboardStore.setUpKeyListener(shortcut: self.kfName2)
                }
            }
        }
    }
    
}

struct KeyboardViewNew_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardViewNew(kfKeyboardStore: KFKeyboardStore(), kfName2: Shortcut(id: "test", name: KeyboardShortcuts.Name("test")))
    }
}
