//
//  Keycap.swift
//  KeyboardFriend
//
//  Created by Fredrik Lindner on 2023-07-13.
//

import SwiftUI

struct Keycap: View {
    let width: Double
    let scale: Double
    let text: String
    
    
    var body: some View {
        ZStack {
            let label = QMKKeycodeMap.getLabelForQMKKeycode(text)
            switch label.type {
            case .Text:
                    RoundedRectangle(cornerRadius: scale/9, style: .circular)
                        .frame(width: width * scale , height: scale)
                        .overlay(
                            Text(label.content)
                                .foregroundColor(.white)
                                .padding(5)
                                .fontDesign(.monospaced)
                                .fontWeight(.bold)
                                .font(.title2)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        )
            case .LayerSymbol:
                    RoundedRectangle(cornerRadius: scale/9, style: .circular)
                    .fill(Color.accentColor)
                        .frame(width: width * scale , height: scale)
                        .overlay(
                            Text(label.layerText!)
                                .foregroundColor(.white)
                                .padding(5)
                                .fontDesign(.monospaced)
                                .fontWeight(.bold)
                                .font(.title2)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .offset(x: 0, y: -scale/4)
                        )
                    RoundedRectangle(cornerRadius: scale/9, style: .circular)
                        .fill(.gray)
                        .frame(width: width * scale/2, height: scale/2)
                        .overlay(
                            Text(label.content)
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontDesign(.monospaced)
                                .fontWeight(.bold)
                        )
                        .offset(x: 0, y: scale/5)
                
            }
        }
    }
}

struct Keycap_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Keycap(width: 1.0, scale: 64, text: "M")
                .previewLayout(PreviewLayout.sizeThatFits)
                .previewDisplayName("M")
            
            Keycap(width: 1.0, scale: 64, text: "TT(3)")
                .previewLayout(PreviewLayout.sizeThatFits)
                .previewDisplayName("MO(3)")
        }
    }
}
