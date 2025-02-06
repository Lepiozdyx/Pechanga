//
//  TopBarButton.swift
//  Pechanga
//
//  Created by J on 05.02.2025.
//

import SwiftUI

struct TopBarButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            CapsuleButton(text: "", width: 50, height: 50)
                .overlay {
                    Image(systemName: "playpause")
                        .font(.system(size: 22))
                        .foregroundStyle(.black)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TopBarButton(action: {})
}
