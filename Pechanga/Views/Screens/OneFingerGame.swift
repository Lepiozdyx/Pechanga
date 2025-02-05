//
//  OneFingerGame.swift
//  Pechanga
//
//  Created by Alex on 03.02.2025.
//

import SwiftUI

struct OneFingerGame: View {
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Backgr()
                
                // Top bar
                
                // Game area with falling elements
                gameArea
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
                        context.draw(image, at: element.position, anchor: .center)
                    }
                }
            }
            
            // Треугольник внизу экрана
            Triangle(
                vertices: viewModel.vertices,
                rotation: viewModel.triangleRotation
            ) {
                viewModel.rotateTriangle()
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
    OneFingerGame()
}
