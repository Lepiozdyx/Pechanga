//
//  FallingElementView.swift
//  Pechanga
//
//  Created by Alex on 05.02.2025.
//

import SwiftUI

struct FallingElementView: View {
    let element: FallingElement
    
    var body: some View {
        Image(element.element.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: GameConfig.elementSize, height: GameConfig.elementSize)
            .position(element.position)
            .opacity(element.opacity)
    }
}
