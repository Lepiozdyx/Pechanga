//
//  Rectngl.swift
//  Pechanga
//
//  Created by Alex on 02.02.2025.
//

import SwiftUI

struct Rectngl: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(maxWidth: width, maxHeight: height)
            .foregroundStyle(Color.asphaltGradient)
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.milkcoffee, lineWidth: 1.5)
            }
    }
}

#Preview {
    Rectngl(width: 350, height: 350)
}
