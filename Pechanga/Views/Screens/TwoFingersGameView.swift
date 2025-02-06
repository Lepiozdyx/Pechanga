//
//  TwoFingersGameView.swift
//  Pechanga
//
//  Created by J on 06.02.2025.
//

import SwiftUI

struct TwoFingersGameView: View {
    @StateObject private var viewModel = GameViewModel(gameMode: .twoFingers)
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Backgr()
                
                // Game area with falling elements
                gameArea
                
                // Top bar with score and lives
                topBar
                
                // Overlays
                MenuOverlays(
                    viewModel: viewModel,
                    dismiss: dismiss
                )
            }
            .onChange(of: scenePhase) { newPhase in
                handleScenePhaseChange(newPhase)
            }
            .onAppear {
                viewModel.setupScreen(
                    size: geometry.size,
                    safeArea: geometry.safeAreaInsets
                )
            }
            .onChange(of: geometry.size) { newSize in
                viewModel.setupScreen(
                    size: newSize,
                    safeArea: geometry.safeAreaInsets
                )
            }
            .onDisappear {
                viewModel.cleanup()
            }
        }
        .navigationBarHidden(true)
    }
    
    private var topBar: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top) {
                TopBarButton {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.pauseGame()
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Counter(value: viewModel.gameState.score)
                    LivesCounter(lives: viewModel.gameState.lives)
                }
            }

            Spacer()
        }
        .padding()
    }
    
    private var gameArea: some View {
        ZStack(alignment: .bottom) {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    for element in viewModel.fallingElements {
                        let image = context.resolve(Image(element.element.imageName))
                        context.opacity = element.opacity
                        
                        // Создаем прямоугольник с нужными размерами
                        let rect = CGRect(
                            x: element.position.x - GameConfig.elementSize/2,
                            y: element.position.y - GameConfig.elementSize/2,
                            width: GameConfig.elementSize,
                            height: GameConfig.elementSize * 1.6
                        )
                        
                        // Рисуем изображение в заданном прямоугольнике
                        context.draw(image, in: rect)
                    }
                }
            }
            
            // Two triangles at the bottom
            HStack(spacing: GameConfig.triangleSpacing) {
                Triangle(
                    vertices: viewModel.vertices[0],
                    rotation: viewModel.triangleRotations[0],
                    triangleIndex: 0
                ) { index in
                    viewModel.rotateTriangle(at: index)
                }
                
                Triangle(
                    vertices: viewModel.vertices[1],
                    rotation: viewModel.triangleRotations[1],
                    triangleIndex: 1
                ) { index in
                    viewModel.rotateTriangle(at: index)
                }
            }
        }
    }
    
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .inactive, .background:
            viewModel.pauseGame()
        case .active:
            break
        @unknown default:
            break
        }
    }
}

#Preview {
    TwoFingersGameView()
}
