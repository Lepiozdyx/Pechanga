//
//  Counter.swift
//  Pechanga
//
//  Created by J on 02.02.2025.
//

import SwiftUI

struct Counter: View {
    let value: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                Circle()
                    .frame(maxHeight: 35)
                    .foregroundStyle(.milkcoffee)
                    .overlay {
                        Circle()
                            .stroke(Color.black, lineWidth: 1.5)
                    }
                    .overlay {
                        HStack(spacing: 0) {
                            Image(.ice)
                                .resizable()
                            Image(.fire)
                                .resizable()
                            Image(.earth)
                                .resizable()
                        }
                        .frame(maxWidth: 30, maxHeight: 20)
                    }
                
                CapsuleButton(text: "\(value)", width: 100, height: 35)
            }
        }
    }
}

#Preview {
    Counter(value: 199)
}
