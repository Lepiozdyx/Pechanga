//
//  Triangle.swift
//  Pechanga
//
//  Created by Alex on 04.02.2025.
//

import SwiftUI

struct Triangle: View {
    let vertices: [Vertex]
    let rotation: Double
    let triangleIndex: Int
    var onTap: (Int) -> Void
    
    private let triangleSize: CGFloat = 160
    private let elementSize: CGFloat = 40
    private let rotationAnchor = UnitPoint(x: 0.5, y: 0.60)
    
    var body: some View {
        ZStack {
            // Layer 1: Rotating triangle
            Image(.triangle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: triangleSize)
                .rotationEffect(.degrees(rotation), anchor: rotationAnchor)
            
            // Layer 2: Elements that move between positions
            ZStack {
                // Top position
                ElementView(
                    element: vertices[0].element,
                    offset: CGPoint(x: 0, y: -triangleSize * 0.25)
                )
                
                // Bottom left position
                ElementView(
                    element: vertices[1].element,
                    offset: CGPoint(x: -triangleSize * 0.3, y: triangleSize * 0.3)
                )
                
                // Bottom right position
                ElementView(
                    element: vertices[2].element,
                    offset: CGPoint(x: triangleSize * 0.3, y: triangleSize * 0.3)
                )
            }
        }
        .frame(width: triangleSize, height: triangleSize)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap(triangleIndex)
        }
    }
}

private struct ElementView: View {
    let element: Element
    let offset: CGPoint
    
    var body: some View {
        Image(element.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 40)
            .offset(x: offset.x, y: offset.y)
    }
}
