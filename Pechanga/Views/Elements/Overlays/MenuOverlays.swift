//
//  MenuOverlays.swift
//  Pechanga
//
//  Created by Alex on 05.02.2025.
//

import SwiftUI

struct MenuOverlays: View {
    @ObservedObject var viewModel: GameViewModel
    let dismiss: DismissAction
    
    var body: some View {
        ZStack {
            // Pause menu overlay
            if viewModel.gameState.isPaused {
                PauseMenu(
                    onResume: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.resumeGame()
                        }
                    },
                    onExit: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            dismiss()
                        }
                    }
                )
            }
            
            // Game over overlay
            if viewModel.gameState.isGameOver {
                GameOverMenu(
                    score: viewModel.gameState.score,
                    onRestart: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.resetGame()
                        }
                    },
                    onExit: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            dismiss()
                        }
                    }
                )
            }
        }
        .transition(.opacity.combined(with: .scale))
    }
}
