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
    @Published private(set) var gameState = GameState()
    @Published var vertices: [Vertex]
    @Published private(set) var triangleRotation: Double = 0
    @Published private(set) var fallingElements: [FallingElement] = []
    
    // MARK: - Private Properties
    private var screenSize: CGSize = .zero
    private var triangleTopPosition: CGPoint = .zero
    private var lastSpawnTime: TimeInterval = 0
    private var animationTimer: AnyCancellable?
    private var safeAreaTop: CGFloat = 0
    
    // MARK: - Init
    init() {
        // Инициализируем вершины с начальным расположением элементов
        self.vertices = [
            Vertex(element: .fire),    // верхняя вершина
            Vertex(element: .earth),   // левая нижняя
            Vertex(element: .ice)      // правая нижняя
        ]
    }
    
    // MARK: - Screen Setup
    func setupScreen(size: CGSize, safeArea: EdgeInsets) {
        screenSize = size
        safeAreaTop = safeArea.top
        
        // Позиционируем треугольник в нижней части экрана (85% от высоты)
        triangleTopPosition = CGPoint(
            x: size.width / 2,
            y: size.height * 0.85
        )
        
        if animationTimer == nil {
            startGame()
        }
    }
    
    // MARK: - Game Control
    private func startGame() {
        resetGame()
        startGameLoop()
    }
    
    func rotateTriangle() {
        guard !gameState.isPaused && !gameState.isGameOver else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Поворачиваем треугольник
            triangleRotation += GameConfig.rotationAngle
            
            // Сдвигаем элементы по часовой стрелке:
            // берем первый элемент и перемещаем его в конец
            let first = vertices.removeFirst()
            vertices.append(first)
        }
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
            spawnNewElement()
            lastSpawnTime = currentTime
        }
        
        updateFallingElements(currentTime: currentTime)
    }
    
    private func spawnNewElement() {
        let randomElement = Element.allCases.randomElement() ?? .fire
        let startPosition = CGPoint(
            x: screenSize.width / 2,
            y: safeAreaTop - GameConfig.elementSize
        )
        
        withAnimation(.easeIn(duration: 0.3)) {
            let newElement = FallingElement(
                element: randomElement,
                position: startPosition,
                startTime: CACurrentMediaTime()
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
            
            // Начальная позиция
            let startY = safeAreaTop - GameConfig.elementSize
            let targetY = triangleTopPosition.y
            let newY = startY + (targetY - startY) * Double(progress)
            let newPosition = CGPoint(x: element.position.x, y: newY)
            
            // Проверяем столкновение точно в позиции вершины треугольника
            if abs(newY - triangleTopPosition.y) < 2.0 {
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
        let topVertex = vertices[0]
        
        withAnimation(.easeOut(duration: 0.2)) {
            if topVertex.element == fallingElement.element {
                // Успешное совпадение
                gameState.incrementScore()
                if let index = fallingElements.firstIndex(where: { $0.id == fallingElement.id }) {
                    fallingElements[index].isCollided = true
                    fallingElements[index].opacity = 0
                }
            } else {
                // Несовпадение - конец игры
                endGame()
            }
        }
    }
    
    func resetGame() {
        gameState.reset()
        triangleRotation = 0
        fallingElements.removeAll()
        lastSpawnTime = CACurrentMediaTime()
        
        vertices = [
            Vertex(element: .fire),    // верхняя вершина
            Vertex(element: .earth),   // левая нижняя
            Vertex(element: .ice)      // правая нижняя
        ]
        
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

// MARK: - Settings Storage
class SettingsStorage {
    static let shared = SettingsStorage()
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let settings = "app_settings"
    }
    
    var settings: AppSettings {
        get {
            guard let data = defaults.data(forKey: Keys.settings),
                  let settings = try? JSONDecoder().decode(AppSettings.self, from: data)
            else { return AppSettings() }
            return settings
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            defaults.set(data, forKey: Keys.settings)
        }
    }
}
