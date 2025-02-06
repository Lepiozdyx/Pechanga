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
    @ObservedObject private var gameManager = GameManager.shared
    @ObservedObject private var skinManager = SkinManager.shared
    
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
    private var isScoreProcessed = false
    
    private let settings = SettingsManager.shared
    
    // MARK: - Init
    init(gameMode: GameMode = .oneFinger) {
        let skinManager = SkinManager.shared
        let currentElements = skinManager.selectedSkin.elements
        let initialVertices = [
            Vertex(element: currentElements[0]),  // ice
            Vertex(element: currentElements[2]),  // earth
            Vertex(element: currentElements[1])   // fire
        ]
        
        self.gameState = GameState(gameMode: gameMode)
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
            settings.vibrate()
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
        
        // Get random base element and map it to current skin
        let baseElement = Element.allCases.filter { $0.baseElement == $0 }.randomElement() ?? .fire
        let currentSkinElements = skinManager.selectedSkin.elements
        let skinElement = currentSkinElements.first { $0.baseElement == baseElement } ?? baseElement
        
        let startPosition = CGPoint(
            x: targetPosition.x,
            y: safeAreaTop - GameConfig.elementSize
        )
        
        withAnimation(.easeIn(duration: 0.3)) {
            let newElement = FallingElement(
                element: skinElement,
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
            // Compare base elements for collision check
            if topVertex.element.baseElement == fallingElement.element.baseElement {
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
        isScoreProcessed = false
        
        // Reset vertices with current skin elements
        let currentElements = skinManager.selectedSkin.elements
        let initialVertices = [
            Vertex(element: currentElements[0]),  // ice
            Vertex(element: currentElements[2]),  // earth
            Vertex(element: currentElements[1])   // fire
        ]
        vertices = gameState.gameMode == .oneFinger ? [initialVertices] : [initialVertices, initialVertices]
        
        animationTimer?.cancel()
        animationTimer = nil
        
        if !screenSize.equalTo(.zero) {
            startGameLoop()
        }
    }
    
    private func processScore() {
        guard !isScoreProcessed else { return }
        gameManager.addPoints(gameState.score)
        gameManager.updateHighScore(score: gameState.score, mode: gameState.gameMode)
        isScoreProcessed = true
    }
    
    private func endGame() {
        gameState.isGameOver = true
        processScore()
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
        processScore()
        animationTimer?.cancel()
        animationTimer = nil
    }
}
