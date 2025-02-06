//
//  Game.swift
//  Pechanga
//
//  Created by Alex on 04.02.2025.
//

import SwiftUI

enum GameMode {
    case oneFinger
    case twoFingers
}

enum Element: String, CaseIterable, Codable {
    case fire, ice, earth
    case fire1, ice1, earth1
    case fire2, ice2, earth2
    
    var imageName: String {
        rawValue
    }
    
    var baseElement: Element {
        switch self {
        case .fire, .fire1, .fire2:
            return .fire
        case .ice, .ice1, .ice2:
            return .ice
        case .earth, .earth1, .earth2:
            return .earth
        }
    }
}

enum ElementSkin: String, CaseIterable, Codable {
    case defaultSkin = "default"
    case skin1 = "skin1"
    case skin2 = "skin2"
    
    var price: Int {
        switch self {
        case .defaultSkin:
            return 0
        case .skin1:
            return 100
        case .skin2:
            return 150
        }
    }
    
    var elements: [Element] {
        switch self {
        case .defaultSkin:
            return [.ice, .fire, .earth]
        case .skin1:
            return [.ice1, .fire1, .earth1]
        case .skin2:
            return [.ice2, .fire2, .earth2]
        }
    }
}

enum SkinPurchaseError: Error {
    case insufficientPoints
    case alreadyOwned
    
    var message: String {
        switch self {
        case .insufficientPoints:
            return "Not enough points to purchase this skin"
        case .alreadyOwned:
            return "You already own this skin"
        }
    }
}

struct FallingElement: Identifiable, Equatable {
    let id = UUID()
    let element: Element
    var position: CGPoint
    var opacity: Double = 1.0
    var isCollided: Bool = false
    let startTime: TimeInterval
    let targetTriangleIndex: Int  // New property to identify target triangle
    
    static func == (lhs: FallingElement, rhs: FallingElement) -> Bool {
        lhs.id == rhs.id
    }
}

struct Vertex: Equatable {
    let element: Element
}

enum GameConfig {
    static let elementSpawnInterval: TimeInterval = 2.0
    static let elementFallDuration: TimeInterval = 4.0
    static let elementSize: CGFloat = 50
    static let rotationAngle: Double = 120
    static let maxLives: Int = 3  // New constant for two fingers mode
    static let triangleSpacing: CGFloat = 8  // Spacing between triangles
}

struct GameState {
    var score: Int = 0
    var lives: Int
    var isGameOver: Bool = false
    var isPaused: Bool = false
    let gameMode: GameMode
    
    init(gameMode: GameMode) {
        self.gameMode = gameMode
        self.lives = gameMode == .twoFingers ? GameConfig.maxLives : 1
    }
    
    mutating func incrementScore() {
        score += 1
    }
    
    mutating func decrementLives() -> Bool {
        lives -= 1
        return lives <= 0
    }
    
    mutating func reset() {
        score = 0
        lives = gameMode == .twoFingers ? GameConfig.maxLives : 1
        isGameOver = false
        isPaused = false
    }
}

struct AppSettings: Codable {
    var isMusicEnabled: Bool
    var isVibrationEnabled: Bool
    var highScoreOneFinger: Int
    var highScoreTwoFingers: Int
    
    init(isMusicEnabled: Bool = true,
         isVibrationEnabled: Bool = true,
         highScoreOneFinger: Int = 0,
         highScoreTwoFingers: Int = 0) {
        self.isMusicEnabled = isMusicEnabled
        self.isVibrationEnabled = isVibrationEnabled
        self.highScoreOneFinger = highScoreOneFinger
        self.highScoreTwoFingers = highScoreTwoFingers
    }
}
