//
//  Extensions.swift
//  Pechanga
//
//  Created by Alex on 01.02.2025.
//

import SwiftUI

// MARK: - View
//struct AsphaltGradientBackground: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .background(LinearGradient(colors: [.asphaltLight, .asphaltDark], startPoint: .top, endPoint: .bottom))
//    }
//}
//
//extension View {
//    func asphaltBackground() -> some View {
//        self.modifier(AsphaltGradientBackground())
//    }
//}

// MARK: - Color
extension Color {
    static let asphaltGradient = LinearGradient(
        colors: [.asphaltLight, .asphaltDark],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Struct
struct Extensions: View {
    var body: some View {
        Color.asphaltGradient
            .ignoresSafeArea()
    }
}

#Preview {
    Extensions()
}
