//
//  KeyboardView.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-04.
//

import SwiftUI

struct KeyboardView: View {
    let maxWidth: Double
    let maxHeight: Double
    let layer: [DrawEntry]
    let scale: Double = 64
    
    var body: some View {
        ZStack {
            ForEach(layer , id: \.matrix) {
                keyButton in
                let width = keyButton.w
                let height = keyButton.h
                Keycap(width: width, height: height, scale: scale, text: keyButton.text)
                    .position(x: ((keyButton.x + width/2.0) * scale), y: ((keyButton.y + height/2.0) * scale))
                    .offset(CGSize(width: keyButton.x + width/2.0, height:(keyButton.y + height/2.0)))
            }
        }
        .drawingGroup()
        .frame(width: (maxWidth+0.22) * scale, height: (maxHeight+0.1) * scale)
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(maxWidth: Double(12), maxHeight: Double(4), layer: [KeyboardFriend.DrawEntry(matrix: [0, 0], x: 0.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_TAB"), KeyboardFriend.DrawEntry(matrix: [0, 1], x: 1.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_Q"), KeyboardFriend.DrawEntry(matrix: [0, 2], x: 2.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_W"), KeyboardFriend.DrawEntry(matrix: [0, 3], x: 3.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_E"), KeyboardFriend.DrawEntry(matrix: [0, 4], x: 4.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_R"), KeyboardFriend.DrawEntry(matrix: [0, 5], x: 5.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_T"), KeyboardFriend.DrawEntry(matrix: [4, 0], x: 6.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_Y"), KeyboardFriend.DrawEntry(matrix: [4, 1], x: 7.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_U"), KeyboardFriend.DrawEntry(matrix: [4, 2], x: 8.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_I"), KeyboardFriend.DrawEntry(matrix: [4, 3], x: 9.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_O"), KeyboardFriend.DrawEntry(matrix: [4, 4], x: 10.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_P"), KeyboardFriend.DrawEntry(matrix: [4, 5], x: 11.0, y: 0.0, w: 1.0, h: 1.0, text: "KC_BSPC"), KeyboardFriend.DrawEntry(matrix: [1, 0], x: 0.0, y: 1.0, w: 1.0, h: 1.0, text: "LCTL_T(KC_ESC)"), KeyboardFriend.DrawEntry(matrix: [1, 1], x: 1.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_A"), KeyboardFriend.DrawEntry(matrix: [1, 2], x: 2.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_S"), KeyboardFriend.DrawEntry(matrix: [1, 3], x: 3.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_D"), KeyboardFriend.DrawEntry(matrix: [1, 4], x: 4.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_F"), KeyboardFriend.DrawEntry(matrix: [1, 5], x: 5.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_G"), KeyboardFriend.DrawEntry(matrix: [5, 0], x: 6.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_H"), KeyboardFriend.DrawEntry(matrix: [5, 1], x: 7.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_J"), KeyboardFriend.DrawEntry(matrix: [5, 2], x: 8.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_K"), KeyboardFriend.DrawEntry(matrix: [5, 3], x: 9.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_L"), KeyboardFriend.DrawEntry(matrix: [5, 4], x: 10.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_SCLN"), KeyboardFriend.DrawEntry(matrix: [5, 5], x: 11.0, y: 1.0, w: 1.0, h: 1.0, text: "KC_QUOT"), KeyboardFriend.DrawEntry(matrix: [2, 0], x: 0.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_LSFT"), KeyboardFriend.DrawEntry(matrix: [2, 1], x: 1.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_Z"), KeyboardFriend.DrawEntry(matrix: [2, 2], x: 2.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_X"), KeyboardFriend.DrawEntry(matrix: [2, 3], x: 3.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_C"), KeyboardFriend.DrawEntry(matrix: [2, 4], x: 4.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_V"), KeyboardFriend.DrawEntry(matrix: [2, 5], x: 5.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_B"), KeyboardFriend.DrawEntry(matrix: [6, 0], x: 6.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_N"), KeyboardFriend.DrawEntry(matrix: [6, 1], x: 7.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_M"), KeyboardFriend.DrawEntry(matrix: [6, 2], x: 8.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_COMM"), KeyboardFriend.DrawEntry(matrix: [6, 3], x: 9.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_DOT"), KeyboardFriend.DrawEntry(matrix: [6, 4], x: 10.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_SLSH"), KeyboardFriend.DrawEntry(matrix: [6, 5], x: 11.0, y: 2.0, w: 1.0, h: 1.0, text: "KC_RALT"), KeyboardFriend.DrawEntry(matrix: [3, 0], x: 0.0, y: 3.0, w: 1.0, h: 1.0, text: "BL_STEP"), KeyboardFriend.DrawEntry(matrix: [3, 1], x: 1.0, y: 3.0, w: 1.0, h: 1.0, text: "MO(3)"), KeyboardFriend.DrawEntry(matrix: [3, 2], x: 2.0, y: 3.0, w: 1.0, h: 1.0, text: "KC_LALT"), KeyboardFriend.DrawEntry(matrix: [7, 3], x: 3.0, y: 3.0, w: 1.0, h: 1.0, text: "KC_LGUI"), KeyboardFriend.DrawEntry(matrix: [7, 4], x: 4.0, y: 3.0, w: 1.0, h: 1.0, text: "MO(1)"), KeyboardFriend.DrawEntry(matrix: [7, 5], x: 5.0, y: 3.0, w: 1.0, h: 1.0, text: "KC_SPC"), KeyboardFriend.DrawEntry(matrix: [7, 1], x: 6.0, y: 3.0, w: 2.0, h: 1.0, text: "KC_ENT"), KeyboardFriend.DrawEntry(matrix: [7, 2], x: 8.0, y: 3.0, w: 1.0, h: 1.0, text: "MO(2)"), KeyboardFriend.DrawEntry(matrix: [3, 3], x: 9.0, y: 3.0, w: 1.0, h: 1.0, text: "KC_LEFT"), KeyboardFriend.DrawEntry(matrix: [3, 4], x: 10.0, y: 3.0, w: 1.0, h: 1.0, text: "KC_DOWN"), KeyboardFriend.DrawEntry(matrix: [3, 5], x: 11.0, y: 3.0, w: 1.0, h: 1.0, text: "KC_UP")])
    }
}
