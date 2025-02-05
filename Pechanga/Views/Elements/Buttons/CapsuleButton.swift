//
//  CapsuleButton.swift
//  Pechanga
//
//  Created by Alex on 01.02.2025.
//

import SwiftUI

struct CapsuleButton: View {
    let text: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Capsule()
            .frame(maxWidth: width, maxHeight: height)
            .foregroundStyle(.milkcoffee)
            .overlay {
                Capsule()
                    .stroke(Color.black, lineWidth: 1.5)
            }
            .overlay {
                Text(text)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }
    }
}

#Preview {
    CapsuleButton(text: "TEXT", width: 250, height: 80)
}
