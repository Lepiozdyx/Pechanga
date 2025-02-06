//
//  OneFingerGame.swift
//  Pechanga
//
//  Created by J on 03.02.2025.
//

import SwiftUI

struct OneFingerGameView: View {
    @StateObject private var viewModel = GameViewModel(gameMode: .oneFinger)
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Backgr()
                
                // Game area with falling elements
                gameArea
                
                // Top bar
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
        VStack {
            HStack {
                TopBarButton {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.pauseGame()
                    }
                }
                
                Spacer()
                
                Counter(value: viewModel.gameState.score)
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
                        
                        let rect = CGRect(
                            x: element.position.x - GameConfig.elementSize/2,
                            y: element.position.y - GameConfig.elementSize/2,
                            width: GameConfig.elementSize,
                            height: GameConfig.elementSize * 1.6
                        )
                        
                        context.draw(image, in: rect)
                    }
                }
            }
            
            // Triangle at the bottom
            Triangle(
                vertices: viewModel.vertices[0],
                rotation: viewModel.triangleRotations[0],
                triangleIndex: 0
            ) { index in
                viewModel.rotateTriangle(at: index)
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
    OneFingerGameView()
}
