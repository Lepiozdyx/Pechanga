//
//  Tutorial.swift
//  Pechanga
//
//  Created by Alex on 02.02.2025.
//

import SwiftUI

struct Tutorial: View {
    @State private var isAnimate = false
    
    var body: some View {
        ZStack {
            Backgr()
            
            BackButton()
                .padding()
            
            Rectngl(width: 300, height: 300)
                .overlay {
                    VStack(spacing: 16) {
                        Text("TUTORIAL")
                            .foregroundStyle(.milkcoffee)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        
                        VStack(spacing: 10) {
                            Image(.triangle)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160)
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
                                        
                                        Image(.finger)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60)
                                            .offset(x: 25, y: 45)
                                            .scaleEffect(isAnimate ? 1 : 0.94)
                                            .animation(
                                                .easeInOut(duration: 0.5)
                                                .repeatForever(autoreverses: true),
                                                value: isAnimate
                                            )
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
                        
                        //Navigate to GameSelectionView()
                        NavigationLink {
                            GameSelection()
                        } label: {
                            CapsuleButton(text: "CONTINUE", width: 240, height: 54)
                        }
                        .buttonStyle(.plain)
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            isAnimate.toggle()
        }
    }
}

#Preview {
    NavigationView {
        Tutorial()
    }
}
