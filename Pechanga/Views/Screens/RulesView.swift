//
//  RulesView.swift
//  Pechanga
//
//  Created by Alex on 06.02.2025.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        ZStack {
            Backgr()
            
            BackButton()
                .padding()
            
            Rectngl(width: 300, height: 350)
                .overlay {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            Text("RULES")
                                .foregroundStyle(.milkcoffee)
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                            
                            VStack(spacing: 10) {
                                Image(.triangle)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .overlay {
                                        ZStack {
                                            VStack {
                                                Image(.ice)
                                                    .resizable()
                                                    .scaledToFit()
                                                
                                                HStack(spacing: 0) {
                                                    Image(.fire)
                                                        .resizable()
                                                        .scaledToFit()
                                                    
                                                    Spacer()
                                                    
                                                    Image(.earth)
                                                        .resizable()
                                                        .scaledToFit()
                                                }
                                                .padding(.horizontal)
                                            }
                                        }
                                    }
                                    .overlay {
                                        HStack {
                                            Image(systemName: "arrow.right")
                                                .foregroundStyle(.milkcoffee)
                                                .font(.system(size: 18))
                                                .rotationEffect(.degrees(-50))
                                            
                                            Spacer()
                                            
                                            Image(systemName: "arrow.right")
                                                .foregroundStyle(.milkcoffee)
                                                .font(.system(size: 18))
                                                .rotationEffect(.degrees(50))
                                        }
                                        .offset(x: 0, y: -20)
                                    }
                                
                                Image(systemName: "arrow.left")
                                    .foregroundStyle(.milkcoffee)
                                    .font(.system(size: 18))
                            }
                            
                            Text("The player controls a triangle with three types of feathers — fire, ice, and earth — and must switch them to match the falling feather with the active one on the triangle; one mistake ends the game. In two-finger mode, you have 3 chances to make a mistake.")
                                .foregroundStyle(.milkcoffee)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RulesView()
}
