//
//  GameViewModel.swift
//  Pechanga
//
//  Created by Alex on 04.02.2025.
//

import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var gameState: GameState
    @Published var vertices: [[Vertex]]
    @Published private(set) var triangleRotations: [Double]
    @Published private(set) var fallingElements: [FallingElement] = []
    
    // MARK: - Private Properties
    private var screenSize: CGSize = .zero
    private var trianglePositions: [CGPoint] = []
    private var lastSpawnTime: TimeInterval = 0
    private var animationTimer: AnyCancellable?
    private var safeAreaTop: CGFloat = 0
    
    // MARK: - Init
    init(gameMode: GameMode = .oneFinger) {
        self.gameState = GameState(gameMode: gameMode)
        
        let initialVertices = [
            Vertex(element: .fire),
            Vertex(element: .earth),
            Vertex(element: .ice)
        ]
        
        self.vertices = gameMode == .oneFinger ? [initialVertices] : [initialVertices, initialVertices]
        self.triangleRotations = gameMode == .oneFinger ? [0] : [0, 0]
    }
    
    // MARK: - Screen Setup
    func setupScreen(size: CGSize, safeArea: EdgeInsets) {
        screenSize = size
        safeAreaTop = safeArea.top
        
        if gameState.gameMode == .oneFinger {
            // Single triangle centered
            trianglePositions = [
                CGPoint(x: size.width / 2, y: size.height * 0.85)
            ]
        } else {
            // Two triangles with proper spacing
            let triangleWidth = GameConfig.elementSize * 3
            let spacing = GameConfig.triangleSpacing
            let totalWidth = (triangleWidth * 2) + spacing
            let startX = (size.width - totalWidth) / 2
            
            trianglePositions = [
                CGPoint(x: startX + (triangleWidth / 2), y: size.height * 0.85),
                CGPoint(x: startX + triangleWidth + spacing + (triangleWidth / 2), y: size.height * 0.85)
            ]
        }
        
        if animationTimer == nil {
            startGame()
        }
    }
    
    // MARK: - Game Control
    func rotateTriangle(at index: Int) {
        guard !gameState.isPaused && !gameState.isGameOver,
              index < triangleRotations.count else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            triangleRotations[index] += GameConfig.rotationAngle
            
            var triangleVertices = vertices[index]
            let first = triangleVertices.removeFirst()
            triangleVertices.append(first)
            vertices[index] = triangleVertices
        }
    }
    
    private func startGame() {
        resetGame()
        startGameLoop()
    }
    
    private func startGameLoop() {
        animationTimer = Timer.publish(every: 1/60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] currentTime in
                guard let self = self else { return }
                self.updateGame(currentTime: currentTime.timeIntervalSinceReferenceDate)
            }
    }
    
    private func updateGame(currentTime: TimeInterval) {
        guard !gameState.isPaused && !gameState.isGameOver else { return }
        
        if currentTime - lastSpawnTime >= GameConfig.elementSpawnInterval {
            spawnNewElements()
            lastSpawnTime = currentTime
        }
        
        updateFallingElements(currentTime: currentTime)
    }
    
    private func spawnNewElements() {
        if gameState.gameMode == .oneFinger {
            spawnSingleElement(triangleIndex: 0)
        } else {
            spawnSingleElement(triangleIndex: 0)
            spawnSingleElement(triangleIndex: 1)
        }
    }
    
    private func spawnSingleElement(triangleIndex: Int) {
        guard triangleIndex < trianglePositions.count else { return }
        
        let targetPosition = trianglePositions[triangleIndex]
        let randomElement = Element.allCases.randomElement() ?? .fire
        
        let startPosition = CGPoint(
            x: targetPosition.x,
            y: safeAreaTop - GameConfig.elementSize
        )
        
        withAnimation(.easeIn(duration: 0.3)) {
            let newElement = FallingElement(
                element: randomElement,
                position: startPosition,
                startTime: CACurrentMediaTime(),
                targetTriangleIndex: triangleIndex
            )
            fallingElements.append(newElement)
        }
    }
    
    private func updateFallingElements(currentTime: TimeInterval) {
        var updatedElements: [FallingElement] = []
        let currentMediaTime = CACurrentMediaTime()
        
        for element in fallingElements {
            guard !element.isCollided else { continue }
            
            let elapsedTime = currentMediaTime - element.startTime
            let progress = min(elapsedTime / GameConfig.elementFallDuration, 1.0)
            
            let targetPosition = trianglePositions[element.targetTriangleIndex]
            let startY = safeAreaTop - GameConfig.elementSize
            let newY = startY + (targetPosition.y - startY) * progress
            
            // Maintain the same X position throughout the fall
            let newPosition = CGPoint(x: targetPosition.x, y: newY)
            
            if abs(newY - targetPosition.y) < 2.0 {
                checkCollision(with: element)
                continue
            }
            
            var updatedElement = element
            updatedElement.position = newPosition
            updatedElements.append(updatedElement)
        }
        
        fallingElements = updatedElements
    }
    
    private func checkCollision(with fallingElement: FallingElement) {
        let triangleIndex = fallingElement.targetTriangleIndex
        guard triangleIndex < vertices.count else { return }
        
        let topVertex = vertices[triangleIndex][0]
        
        withAnimation(.easeOut(duration: 0.2)) {
            if topVertex.element == fallingElement.element {
                gameState.incrementScore()
                if let index = fallingElements.firstIndex(where: { $0.id == fallingElement.id }) {
                    fallingElements[index].isCollided = true
                    fallingElements[index].opacity = 0
                }
            } else {
                let shouldEndGame = gameState.decrementLives()
                if shouldEndGame {
                    endGame()
                }
            }
        }
    }
    
    func resetGame() {
        gameState.reset()
        triangleRotations = gameState.gameMode == .oneFinger ? [0] : [0, 0]
        fallingElements.removeAll()
        lastSpawnTime = CACurrentMediaTime()
        
        let initialVertices = [
            Vertex(element: .fire),
            Vertex(element: .earth),
            Vertex(element: .ice)
        ]
        vertices = gameState.gameMode == .oneFinger ? [initialVertices] : [initialVertices, initialVertices]
        
        animationTimer?.cancel()
        animationTimer = nil
        
        if !screenSize.equalTo(.zero) {
            startGameLoop()
        }
    }
    
    private func endGame() {
        gameState.isGameOver = true
        animationTimer?.cancel()
        animationTimer = nil
    }
    
    func pauseGame() {
        gameState.isPaused = true
        animationTimer?.cancel()
    }
    
    func resumeGame() {
        gameState.isPaused = false
        lastSpawnTime = CACurrentMediaTime()
        startGameLoop()
    }
    
    func cleanup() {
        animationTimer?.cancel()
        animationTimer = nil
    }
}
