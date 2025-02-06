//
//  GameOverView.swift
//  Pechanga
//
//  Created by J on 05.02.2025.
//

import SwiftUI

struct GameOverMenu: View {
    let score: Int
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            Rectngl(width: 300, height: 250)
                .overlay {
                    VStack(spacing: 20) {
                        Text("GAME OVER")
                            .foregroundStyle(.milkcoffee)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        
                        Text("Score: \(score)")
                            .foregroundStyle(.milkcoffee)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        Button {
                            onRestart()
                        } label: {
                            CapsuleButton(text: "TRY AGAIN", width: 240, height: 54)
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
    GameOverMenu(score: 33, onRestart: {}, onExit: {})
}
