//
//  MainMenu.swift
//  Pechanga
//
//  Created by Alex on 02.02.2025.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject private var gameManager = GameManager.shared
    @State private var isMusicEnabled = SettingsManager.shared.isMusicEnabled
    @Environment(\.scenePhase) private var scenePhase
    private let settings = SettingsManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Backgr()
                
                VStack(spacing: 10) {
                    Counter(value: gameManager.totalPoints)
                    
                    Spacer()
                    
                    NavigationLink {
                        TutorialView()
                    } label: {
                        CapsuleButton(text: "GAMES", width: 260, height: 54)
                    }
                    .buttonStyle(.plain)
                    
                    HStack {
                        NavigationLink {
                            // ShopView()
                        } label: {
                            CapsuleButton(text: "SHOP", width: 260, height: 54)
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                             HighScoreView()
                        } label: {
                            CapsuleButton(text: "HIGH SCORE", width: 260, height: 60)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack {
                        NavigationLink {
                             RulesView()
                        } label: {
                            CapsuleButton(text: "RULES", width: 260, height: 54)
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                             OptionsView()
                        } label: {
                            CapsuleButton(text: "OPTIONS", width: 260, height: 54)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            settings.playBackgroundMusic()
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                settings.playBackgroundMusic()
            case .background, .inactive:
                settings.stopBackgroundMusic()
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    MainMenuView()
}
