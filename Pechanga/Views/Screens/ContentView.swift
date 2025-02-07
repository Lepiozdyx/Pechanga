//
//  ContentView.swift
//  Pechanga
//
//  Created by J on 01.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = InitialManager()
    
    var body: some View {
        Group {
            switch viewModel.appState {
            case .loading:
                LoadingView()
                    .transition(.opacity)
            case .initial:
                if let url = viewModel.networkManager.provenURL {
                    WebManager(
                        url: url,
                        networkManager: viewModel.networkManager
                    )
                } else {
                    WebManager(
                        url: NetworkManager.targetURL,
                        networkManager: viewModel.networkManager
                    )
                }
            case .root:
                MainMenuView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView()
}
