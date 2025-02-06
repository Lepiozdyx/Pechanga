//
//  SkinSetView.swift
//  Pechanga
//
//  Created by Alex on 06.02.2025.
//

import SwiftUI

struct SkinSetView: View {
    let skin: ElementSkin
    let isSelected: Bool
    let isOwned: Bool
    let onPurchase: () -> Void
    let onSelect: () -> Void
    
    var body: some View {
        ZStack {
            Rectngl(width: 280, height: 180)
            
            VStack(spacing: 16) {
                HStack {
                    ForEach(skin.elements, id: \.self) { element in
                        Image(element.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                    }
                }
                
                Button {
                    if isOwned {
                        onSelect()
                    } else {
                        onPurchase()
                    }
                } label: {
                    Capsule()
                        .frame(width: 220, height: 52)
                        .foregroundStyle(isSelected ? .green.opacity(0.8) : .milkcoffee)
                        .overlay {
                            Capsule()
                                .stroke(Color.black, lineWidth: 1.5)
                        }
                        .overlay {
                            Text(buttonTitle)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                        }
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
    }
    
    private var buttonTitle: String {
        if !isOwned {
            return "BUY \(skin.price)"
        }
        return isSelected ? "SELECTED" : "SELECT"
    }
}

#Preview {
    VStack {
        SkinSetView(
            skin: .defaultSkin,
            isSelected: true,
            isOwned: true,
            onPurchase: {},
            onSelect: {}
        )
        
        SkinSetView(
            skin: .skin1,
            isSelected: false,
            isOwned: true,
            onPurchase: {},
            onSelect: {}
        )
        
        SkinSetView(
            skin: .skin2,
            isSelected: false,
            isOwned: false,
            onPurchase: {},
            onSelect: {}
        )
    }
}
