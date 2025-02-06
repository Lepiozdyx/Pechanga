//
//  PauseMenu.swift
//  Pechanga
//
//  Created by J on 05.02.2025.
//

import SwiftUI

struct PauseMenu: View {
    let onResume: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            Rectngl(width: 300, height: 250)
                .overlay {
                    VStack(spacing: 20) {
                        Text("PAUSE")
                            .foregroundStyle(.milkcoffee)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        
                        Button {
                            onResume()
                        } label: {
                            CapsuleButton(text: "RESUME", width: 240, height: 54)
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            onExit()
                        } label: {
                            CapsuleButton(text: "MENU", width: 240, height: 54)
                        }
                        .buttonStyle(.plain)
                    }
                }
        }
    }
}

#Preview {
    PauseMenu(onResume: {}, onExit: {})
}
