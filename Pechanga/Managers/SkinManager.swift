//
//  SkinManager.swift
//  Pechanga
//
//  Created by Alex on 06.02.2025.
//

import Foundation

@MainActor
final class SkinManager: ObservableObject {
    static let shared = SkinManager()
    
    @Published private(set) var selectedSkin: ElementSkin
    @Published private(set) var ownedSkins: Set<ElementSkin>
    
    private enum Keys: String {
        case selectedSkin
        case ownedSkins
    }
    
    private let defaults = UserDefaults.standard
    
    private init() {
        // Initialize with default values
        self.selectedSkin = .defaultSkin
        self.ownedSkins = [.defaultSkin]
        
        // Load saved data
        if let savedSkinRaw = defaults.string(forKey: Keys.selectedSkin.rawValue),
           let savedSkin = ElementSkin(rawValue: savedSkinRaw) {
            self.selectedSkin = savedSkin
        }
        
        if let savedSkinsData = defaults.data(forKey: Keys.ownedSkins.rawValue),
           let decodedSkins = try? JSONDecoder().decode(Set<ElementSkin>.self, from: savedSkinsData) {
            self.ownedSkins = decodedSkins
        }
    }
    
    func selectSkin(_ skin: ElementSkin) {
        guard ownedSkins.contains(skin) else { return }
        selectedSkin = skin
        defaults.set(skin.rawValue, forKey: Keys.selectedSkin.rawValue)
    }
    
    func purchaseSkin(_ skin: ElementSkin) throws {
        guard !ownedSkins.contains(skin) else {
            throw SkinPurchaseError.alreadyOwned
        }
        
        let gameManager = GameManager.shared
        guard gameManager.totalPoints >= skin.price else {
            throw SkinPurchaseError.insufficientPoints
        }
        
        // Deduct points and add skin to owned collection
        gameManager.deductPoints(skin.price)
        ownedSkins.insert(skin)
        
        // Save owned skins
        if let encodedSkins = try? JSONEncoder().encode(ownedSkins) {
            defaults.set(encodedSkins, forKey: Keys.ownedSkins.rawValue)
        }
    }
    
    func isSkinOwned(_ skin: ElementSkin) -> Bool {
        ownedSkins.contains(skin)
    }
}
