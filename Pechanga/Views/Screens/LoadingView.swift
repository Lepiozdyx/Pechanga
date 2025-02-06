//
//  LoadingView.swift
//  Pechanga
//
//  Created by Alex on 06.02.2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            Backgr()
            
            VStack(spacing: 40) {
                VStack(spacing: 0) {
                    Image(.fire)
                        .resizable()
                        .scaledToFit()
                    HStack {
                        Image(.ice)
                            .resizable()
                            .scaledToFit()
                        Image(.earth)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 150, height: 150)
                
                VStack {
                    Text("LOADING...")
                        .foregroundStyle(.milkcoffee)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    Capsule()
                        .frame(width: 250, height: 30)
                        .foregroundStyle(.asphaltDark)
                        .overlay {
                            Capsule()
                                .stroke(.milkcoffee, lineWidth: 0.5)
                        }
                        .overlay(alignment: .leading) {
                            Capsule()
                                .foregroundStyle(.milkcoffee)
                                .frame(width: progress * 250, height: 30)
                        }
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 0.9)) {
                progress = 1
            }
        }
    }
}

#Preview {
    LoadingView()
}
