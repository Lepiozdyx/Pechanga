//
//  GameSelection.swift
//  Pechanga
//
//  Created by Alex on 02.02.2025.
//

import SwiftUI

struct GameSelectionView: View {
    var body: some View {
        ZStack {
            Backgr()
            
            BackButton()
                .padding()

            HStack {
                NavigationLink {
                     OneFingerGameView()
                } label: {
                    CapsuleButton(text: "ONE FINGER", width: 260, height: 54)
                }
                .buttonStyle(.plain)

                NavigationLink {
                    // TwoFingersGameView()
                } label: {
                    CapsuleButton(text: "TWO FINGERS", width: 260, height: 54)
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationView {
        GameSelectionView()
    }
}
