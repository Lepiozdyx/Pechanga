//
//  LivesCounter.swift
//  Pechanga
//
//  Created by J on 06.02.2025.
//

import SwiftUI

struct LivesCounter: View {
    let lives: Int
    
    var body: some View {
        HStack {
            CapsuleButton(
                text: "",
                width: 35,
                height: 35
            )
            .overlay {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 18))
            }
            
            CapsuleButton(
                text: "\(lives)",
                width: 50,
                height: 35
            )
        }
    }
}

#Preview {
    LivesCounter(lives: 3)
}
