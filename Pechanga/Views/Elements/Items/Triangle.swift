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
    var onTap: () -> Void
    
    private let triangleSize: CGFloat = 160
    private let elementSize: CGFloat = 40
    
    private let rotationAnchor = UnitPoint(x: 0.5, y: 0.60)
    
    var body: some View {
        ZStack {
            // Слой 1: Вращающийся треугольник
            Image(.triangle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: triangleSize)
                .rotationEffect(.degrees(rotation), anchor: rotationAnchor)
            
            // Слой 2: Элементы, которые перемещаются между позициями
            ZStack {
                // Верхняя позиция
                ElementView(
                    element: vertices[0].element,
                    offset: CGPoint(x: 0, y: -triangleSize * 0.25)
                )
                
                // Нижняя левая позиция
                ElementView(
                    element: vertices[1].element,
                    offset: CGPoint(x: -triangleSize * 0.3, y: triangleSize * 0.3)
                )
                
                // Нижняя правая позиция
                ElementView(
                    element: vertices[2].element,
                    offset: CGPoint(x: triangleSize * 0.3, y: triangleSize * 0.3)
                )
            }
        }
        .frame(width: triangleSize, height: triangleSize)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
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
