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
                RoundedRectangle(cornerRadius: scale/6)
                    .frame(width: width * scale , height: scale)
                    .border(.bar, width: 2)
                    .overlay(
                        Text(QMKKeycodeMap.convertQMKKeycode(keyButton.text))
                            .foregroundColor(.white)
                            .padding()
                            .fontDesign(.monospaced)
                            .fontWeight(.bold)
                    )
                    .position(x: ((keyButton.x + width/2.0) * scale), y: ((keyButton.y + 1.0/2.0) * scale))
            }
        }.frame(width: (maxWidth+1.0) * scale, height: (maxHeight+1.0) * scale)
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(maxWidth: Double(14), maxHeight: Double(4), layer: [DrawEntry(matrix: [0, 0], x: 0.0, y: 0.0, w: 1.0, text: "KC_ESC"), DrawEntry(matrix: [0, 1], x: 1.0, y: 0.0, w: 1.0, text: "KC_1"), DrawEntry(matrix: [0, 2], x: 2.0, y: 0.0, w: 1.0, text: "KC_2"), DrawEntry(matrix: [0, 3], x: 3.0, y: 0.0, w: 1.0, text: "KC_3"), DrawEntry(matrix: [0, 4], x: 4.0, y: 0.0, w: 1.0, text: "KC_4"), DrawEntry(matrix: [0, 5], x: 5.0, y: 0.0, w: 1.0, text: "KC_5"), DrawEntry(matrix: [0, 6], x: 6.0, y: 0.0, w: 1.0, text: "KC_6"), DrawEntry(matrix: [0, 7], x: 7.0, y: 0.0, w: 1.0, text: "KC_7"), DrawEntry(matrix: [0, 8], x: 8.0, y: 0.0, w: 1.0, text: "KC_8"), DrawEntry(matrix: [0, 9], x: 9.0, y: 0.0, w: 1.0, text: "KC_9"), DrawEntry(matrix: [0, 10], x: 10.0, y: 0.0, w: 1.0, text: "KC_0"), DrawEntry(matrix: [0, 11], x: 11.0, y: 0.0, w: 1.0, text: "KC_MINS"), DrawEntry(matrix: [0, 12], x: 12.0, y: 0.0, w: 1.0, text: "KC_EQL"), DrawEntry(matrix: [0, 13], x: 13.0, y: 0.0, w: 1.0, text: "KC_BSLS"), DrawEntry(matrix: [2, 13], x: 14.0, y: 0.0, w: 1.0, text: "KC_DEL"), DrawEntry(matrix: [1, 0], x: 0.0, y: 1.0, w: 1.5, text: "KC_TAB"), DrawEntry(matrix: [1, 1], x: 1.5, y: 1.0, w: 1.0, text: "KC_Q"), DrawEntry(matrix: [1, 2], x: 2.5, y: 1.0, w: 1.0, text: "KC_W"), DrawEntry(matrix: [1, 3], x: 3.5, y: 1.0, w: 1.0, text: "KC_E"), DrawEntry(matrix: [1, 4], x: 4.5, y: 1.0, w: 1.0, text: "KC_R"), DrawEntry(matrix: [1, 5], x: 5.5, y: 1.0, w: 1.0, text: "KC_T"), DrawEntry(matrix: [1, 6], x: 6.5, y: 1.0, w: 1.0, text: "KC_Y"), DrawEntry(matrix: [1, 7], x: 7.5, y: 1.0, w: 1.0, text: "KC_U"), DrawEntry(matrix: [1, 8], x: 8.5, y: 1.0, w: 1.0, text: "KC_I"), DrawEntry(matrix: [1, 9], x: 9.5, y: 1.0, w: 1.0, text: "KC_O"), DrawEntry(matrix: [1, 10], x: 10.5, y: 1.0, w: 1.0, text: "KC_P"), DrawEntry(matrix: [1, 11], x: 11.5, y: 1.0, w: 1.0, text: "KC_LBRC"), DrawEntry(matrix: [1, 12], x: 12.5, y: 1.0, w: 1.0, text: "KC_RBRC"), DrawEntry(matrix: [1, 13], x: 13.5, y: 1.0, w: 1.5, text: "KC_BSPC"), DrawEntry(matrix: [2, 0], x: 0.0, y: 2.0, w: 1.75, text: "KC_LCTL"), DrawEntry(matrix: [2, 1], x: 1.75, y: 2.0, w: 1.0, text: "KC_A"), DrawEntry(matrix: [2, 2], x: 2.75, y: 2.0, w: 1.0, text: "KC_S"), DrawEntry(matrix: [2, 3], x: 3.75, y: 2.0, w: 1.0, text: "KC_D"), DrawEntry(matrix: [2, 4], x: 4.75, y: 2.0, w: 1.0, text: "KC_F"), DrawEntry(matrix: [2, 5], x: 5.75, y: 2.0, w: 1.0, text: "KC_G"), DrawEntry(matrix: [2, 6], x: 6.75, y: 2.0, w: 1.0, text: "KC_H"), DrawEntry(matrix: [2, 7], x: 7.75, y: 2.0, w: 1.0, text: "KC_J"), DrawEntry(matrix: [2, 8], x: 8.75, y: 2.0, w: 1.0, text: "KC_K"), DrawEntry(matrix: [2, 9], x: 9.75, y: 2.0, w: 1.0, text: "KC_L"), DrawEntry(matrix: [2, 10], x: 10.75, y: 2.0, w: 1.0, text: "KC_SCLN"), DrawEntry(matrix: [2, 11], x: 11.75, y: 2.0, w: 1.0, text: "KC_QUOT"), DrawEntry(matrix: [2, 12], x: 12.75, y: 2.0, w: 2.25, text: "KC_ENT"), DrawEntry(matrix: [3, 0], x: 0.0, y: 3.0, w: 2.25, text: "KC_LSFT"), DrawEntry(matrix: [3, 2], x: 2.25, y: 3.0, w: 1.0, text: "KC_Z"), DrawEntry(matrix: [3, 3], x: 3.25, y: 3.0, w: 1.0, text: "KC_X"), DrawEntry(matrix: [3, 4], x: 4.25, y: 3.0, w: 1.0, text: "KC_C"), DrawEntry(matrix: [3, 5], x: 5.25, y: 3.0, w: 1.0, text: "KC_V"), DrawEntry(matrix: [3, 6], x: 6.25, y: 3.0, w: 1.0, text: "KC_B"), DrawEntry(matrix: [3, 7], x: 7.25, y: 3.0, w: 1.0, text: "KC_N"), DrawEntry(matrix: [3, 8], x: 8.25, y: 3.0, w: 1.0, text: "KC_M"), DrawEntry(matrix: [3, 9], x: 9.25, y: 3.0, w: 1.0, text: "KC_COMM"), DrawEntry(matrix: [3, 10], x: 10.25, y: 3.0, w: 1.0, text: "KC_DOT"), DrawEntry(matrix: [3, 11], x: 11.25, y: 3.0, w: 1.0, text: "KC_SLSH"), DrawEntry(matrix: [3, 12], x: 12.25, y: 3.0, w: 1.75, text: "KC_RSFT"), DrawEntry(matrix: [3, 13], x: 14.0, y: 3.0, w: 1.0, text: "ANY(TL_LOWR)"), DrawEntry(matrix: [4, 1], x: 1.5, y: 4.0, w: 1.0, text: "KC_LGUI"), DrawEntry(matrix: [4, 2], x: 2.5, y: 4.0, w: 1.5, text: "KC_LALT"), DrawEntry(matrix: [4, 7], x: 4.0, y: 4.0, w: 7.0, text: "KC_SPC"), DrawEntry(matrix: [4, 11], x: 11.0, y: 4.0, w: 1.5, text: "KC_RALT"), DrawEntry(matrix: [4, 12], x: 12.5, y: 4.0, w: 1.0, text: "ANY(TL_UPPR)")])
    }
}
