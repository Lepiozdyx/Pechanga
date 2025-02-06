//
//  HighScoreView.swift
//  Pechanga
//
//  Created by Alex on 06.02.2025.
//

import SwiftUI

struct HighScoreView: View {
    @StateObject private var gameManager = GameManager.shared
    
    var body: some View {
        ZStack {
            Backgr()
            
            BackButton()
                .padding()
            
            Rectngl(width: 300, height: 300)
                .overlay {
                    VStack(spacing: 20) {
                        Text("HIGH SCORE")
                            .foregroundStyle(.milkcoffee)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        
                        VStack(spacing: 20) {
                            scoreRow(title: "ONE FINGER", score: gameManager.highScoreOneFinger)
                            scoreRow(title: "TWO FINGERS", score: gameManager.highScoreTwoFingers)
                        }
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func scoreRow(title: String, score: Int) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .foregroundStyle(.milkcoffee)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            
            CapsuleButton(text: "\(score)", width: 200, height: 54)
        }
    }
}

#Preview {
    NavigationView {
        HighScoreView()
    }
}
