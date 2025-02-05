//
//  MainMenu.swift
//  Pechanga
//
//  Created by Alex on 02.02.2025.
//

import SwiftUI

struct MainMenu: View {
    var body: some View {
        NavigationView {
            ZStack {
                Backgr()
                
                VStack(spacing: 10) {
                    Counter(value: 100)
                    
                    Spacer()
                    
                    NavigationLink {
                        Tutorial()
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
                            // HighScoreView()
                        } label: {
                            CapsuleButton(text: "HIGH SCORE", width: 260, height: 60)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack {
                        NavigationLink {
                            // RulesView()
                        } label: {
                            CapsuleButton(text: "RULES", width: 260, height: 54)
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                            // OptionsView()
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
    }
}

#Preview {
    MainMenu()
}
