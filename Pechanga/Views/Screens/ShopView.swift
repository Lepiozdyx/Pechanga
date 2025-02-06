//
//  ShopView.swift
//  Pechanga
//
//  Created by Alex on 06.02.2025.
//

import SwiftUI

struct ShopView: View {
    @StateObject private var skinManager = SkinManager.shared
    @StateObject private var gameManager = GameManager.shared
    
//    var isIPad: Bool { UIDevice.current.userInterfaceIdiom == .pad}
    
    var body: some View {
        ZStack {
            Backgr()
            
            BackButton()
                .padding()
            
            VStack {
                Counter(value: gameManager.totalPoints)
                    .padding()
                
                Spacer()
                
                Rectngl(width: 300, height: 400)
                    .overlay {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 10) {
                                ForEach(ElementSkin.allCases, id: \.self) { skin in
                                    SkinSetView(
                                        skin: skin,
                                        isSelected: skinManager.selectedSkin == skin,
                                        isOwned: skinManager.isSkinOwned(skin),
                                        onPurchase: {
                                            purchaseSkin(skin)
                                        },
                                        onSelect: {
                                            skinManager.selectSkin(skin)
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                        .padding(4)
                    }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func purchaseSkin(_ skin: ElementSkin) {
        do {
            try skinManager.purchaseSkin(skin)
            skinManager.selectSkin(skin)
        } catch let error as SkinPurchaseError {
            print(error.message)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

#Preview {
    ShopView()
}
