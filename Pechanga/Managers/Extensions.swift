//
//  Extensions.swift
//  Pechanga
//
//  Created by J on 01.02.2025.
//

import SwiftUI

extension Color {
    static let asphaltGradient = LinearGradient(
        colors: [.asphaltLight, .asphaltDark],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct Extensions: View {
    var body: some View {
        Color.asphaltGradient
            .ignoresSafeArea()
    }
}

#Preview {
    Extensions()
}
