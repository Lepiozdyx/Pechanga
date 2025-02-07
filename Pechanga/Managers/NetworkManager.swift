//
//  NetworkManager.swift
//  Pechanga
//
//  Created by J on 07.02.2025.
//

import UIKit

protocol NetworkManagerProtocol: ObservableObject {
    var provenURL: URL? { get }
    func proveURL(_ url: URL)
    func checkURL() async throws -> Bool
    func getUserAgent(forWV: Bool) -> String
}

final class NetworkManager: NetworkManagerProtocol {
    private enum StorageKey {
        static let savedURL = "saved_url"
        static let badURLs = ["about:blank", "about:srcdoc"]
    }
    
    @Published private(set) var provenURL: URL?
    
    static let targetURL = URL(string: "https://pechangagames.top/time")!
    private let storage: UserDefaults
    private let systemVersion: String
    private var hasStoredURL: Bool = false
    
    init(storage: UserDefaults = .standard, systemVersion: String = UIDevice.current.systemVersion) {
        self.storage = storage
        self.systemVersion = systemVersion
        loadSavedURL()
    }
    
    func proveURL(_ url: URL) {
        guard !hasStoredURL, isURLValid(url) else { return }
        
        storage.set(url.absoluteString, forKey: StorageKey.savedURL)
        provenURL = url
        hasStoredURL = true
    }
    
    func getUserAgent(forWV: Bool) -> String {
        forWV ? webViewUA : networkUA
    }
    
    func checkURL() async throws -> Bool {
        let request = URLRequest(url: Self.targetURL, userAgent: networkUA)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return validateResponse(response)
        } catch {
            return false
        }
    }
}

private extension NetworkManager {
    var webViewUA: String {
        """
        Mozilla/5.0 (iPhone; CPU iPhone OS \(systemVersion.replacingOccurrences(of: ".", with: "_")) \
        like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1
        """
    }
    
    var networkUA: String {
        "TestRequest/1.0 CFNetwork/1410.0.3 Darwin/22.4.0"
    }
    
    func loadSavedURL() {
        guard let urlString = storage.string(forKey: StorageKey.savedURL),
              let url = URL(string: urlString) else { return }
        
        provenURL = url
        hasStoredURL = true
    }
    
    func isURLValid(_ url: URL) -> Bool {
        guard !StorageKey.badURLs.contains(url.absoluteString) else { return false }
        guard let host = url.host else { return false }
        return !host.contains("google.com")
    }
    
    func validateResponse(_ response: URLResponse) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode),
              let finalURL = httpResponse.url,
              let host = finalURL.host else { return false }
        
        return !host.contains("google.com")
    }
}

private extension URLRequest {
    init(url: URL, userAgent: String) {
        self.init(url: url)
        setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
}
