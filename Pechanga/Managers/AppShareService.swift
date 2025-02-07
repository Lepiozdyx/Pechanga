//
//  AppShareService.swift
//  Pechanga
//
//  Created by J on 06.02.2025.
//

import UIKit

final class AppShareService {
    static let shared = AppShareService()
    
    private let appID: String
    private let appStoreURL: URL
    private let shareMessage: String
    
    private init() {
        self.appID = "6741690079"
        self.appStoreURL = URL(string: "https://apps.apple.com/app/id\(appID)")!
        self.shareMessage = "Test yourself in our amazing game!"
    }
    
    func rateApp() {
        let appStoreURL = "itms-apps://apps.apple.com/app/id\(appID)"
        if let url = URL(string: appStoreURL),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(self.appStoreURL)
        }
    }
    
    func shareApp() {
        let items: [Any] = [shareMessage, appStoreURL]
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = window
                activityVC.popoverPresentationController?.sourceRect = CGRect(
                    x: window.frame.width/2,
                    y: window.frame.height/2,
                    width: 0,
                    height: 0
                )
                activityVC.popoverPresentationController?.permittedArrowDirections = []
            }
            
            rootVC.present(activityVC, animated: true)
        }
    }
}
