//
//  BackButton.swift
//  Pechanga
//
//  Created by J on 01.02.2025.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    CapsuleButton(text: "", width: 50, height: 50)
                        .overlay {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 30))
                                .foregroundStyle(.black)
                        }
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    BackButton()
}
