//
//  Keycap.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-13.
//

import SwiftUI

struct Keycap: View {
    let x, y: Double
    
    let width: Double
    let scale: Double
    let text: String
    var body: some View {
        RoundedRectangle(cornerRadius: scale/9, style: .circular)
            .frame(width: width * scale , height: scale)
            .overlay(
                Text(QMKKeycodeMap.convertQMKKeycode(text))
                    .foregroundColor(.white)
                    .padding()
                    .fontDesign(.monospaced)
                    .fontWeight(.bold)
            )
            .frame(width: scale, height: scale)
            .ignoresSafeArea()
    }
}

struct Keycap_Previews: PreviewProvider {
    static var previews: some View {
        Keycap(x: 0, y: 0, width: 1, scale: 64, text: "A")
    }
}
