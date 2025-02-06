//
//  Game.swift
//  Pechanga
//
//  Created by Alex on 04.02.2025.
//

import SwiftUI

// MARK: - Element Type
enum Element: String, CaseIterable, Codable {
    case fire
    case ice
    case earth
    
    var imageName: String {
        rawValue
    }
}

// MARK: - Falling Element
struct FallingElement: Identifiable, Equatable {
    let id = UUID()
    let element: Element
    var position: CGPoint
    var opacity: Double = 1.0
    var isCollided: Bool = false
    let startTime: TimeInterval
    
    static func == (lhs: FallingElement, rhs: FallingElement) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Triangle Vertex
struct Vertex: Equatable {
    let element: Element
}

// MARK: - Game Configuration
enum GameConfig {
    static let elementSpawnInterval: TimeInterval = 2.0
    static let elementFallDuration: TimeInterval = 4.0
    static let elementSize: CGFloat = 50
    static let rotationAngle: Double = 120
}

// MARK: - Game State
struct GameState {
    var score: Int = 0
    var isGameOver: Bool = false
    var isPaused: Bool = false
    
    mutating func incrementScore() {
        score += 1
    }
    
    mutating func reset() {
        score = 0
        isGameOver = false
        isPaused = false
    }
}

// MARK: - App Settings
struct AppSettings: Codable {
    var isMusicEnabled: Bool
    var isVibrationEnabled: Bool
    var highScore: Int
    
    init(isMusicEnabled: Bool = true,
         isVibrationEnabled: Bool = true,
         highScore: Int = 0) {
        self.isMusicEnabled = isMusicEnabled
        self.isVibrationEnabled = isVibrationEnabled
        self.highScore = highScore
    }
}
