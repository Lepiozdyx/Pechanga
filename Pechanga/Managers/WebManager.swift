//
//  WebKitManager.swift
//  Pechanga
//
//  Created by J on 07.02.2025.
//

import SwiftUI
@preconcurrency import WebKit

struct WebManager: UIViewRepresentable {
    private let url: URL
    private let networkManager: any NetworkManagerProtocol
    
    init(url: URL, networkManager: any NetworkManagerProtocol) {
        self.url = url
        self.networkManager = networkManager
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: WebViewConfiguration.default)
        configureWebView(webView, with: context.coordinator)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}

private extension WebManager {
    func configureWebView(_ webView: WKWebView, with coordinator: Coordinator) {
        webView.navigationDelegate = coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = true
        webView.customUserAgent = networkManager.getUserAgent(forWV: true)
    }
}

extension WebManager {
    final class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: WebManager
        
        init(parent: WebManager) {
            self.parent = parent
            super.init()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let finalURL = webView.url else { return }
            
            if finalURL != NetworkManager.targetURL {
                parent.networkManager.proveURL(finalURL)
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            
        }
    }
}

// MARK: - WebView Configuration
private enum WebViewConfiguration {
    static var `default`: WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        return configuration
    }
}
