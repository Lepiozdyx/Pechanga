//
//  GameManager.swift
//  Pechanga
//
//  Created by J on 06.02.2025.
//

import SwiftUI

@MainActor
final class GameManager: ObservableObject {
    static let shared = GameManager()
    
    @Published private(set) var totalPoints: Int
    @Published private(set) var highScoreOneFinger: Int
    @Published private(set) var highScoreTwoFingers: Int
    
    private init() {
        // Initialize with default values first
        self.totalPoints = 0
        self.highScoreOneFinger = 0
        self.highScoreTwoFingers = 0
        
        // Then load saved data if available
        if let data = UserDefaults.standard.data(forKey: "GameData"),
           let decoded = try? JSONDecoder().decode(GameData.self, from: data) {
            self.totalPoints = decoded.totalPoints
            self.highScoreOneFinger = decoded.highScoreOneFinger
            self.highScoreTwoFingers = decoded.highScoreTwoFingers
        }
    }
    
    func addPoints(_ points: Int) {
        totalPoints += points
        saveGameData()
    }
    
    func deductPoints(_ points: Int) {
        totalPoints = max(0, totalPoints - points)
        saveGameData()
    }
    
    func updateHighScore(score: Int, mode: GameMode) {
        switch mode {
        case .oneFinger:
            if score > highScoreOneFinger {
                highScoreOneFinger = score
                saveGameData()
            }
        case .twoFingers:
            if score > highScoreTwoFingers {
                highScoreTwoFingers = score
                saveGameData()
            }
        }
    }
    
    private func saveGameData() {
        let data = GameData(
            totalPoints: totalPoints,
            highScoreOneFinger: highScoreOneFinger,
            highScoreTwoFingers: highScoreTwoFingers
        )
        
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "GameData")
        }
    }
}

private struct GameData: Codable {
    let totalPoints: Int
    let highScoreOneFinger: Int
    let highScoreTwoFingers: Int
}
