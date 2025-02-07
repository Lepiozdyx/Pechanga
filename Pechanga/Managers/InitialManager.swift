//
//  AppViewModel.swift
//  Pechanga
//
//  Created by J on 07.02.2025.
//

import Foundation

enum AppState {
    case loading
    case initial
    case root
}

@MainActor
final class InitialManager: ObservableObject {
    @Published private(set) var appState: AppState = .loading
    
    let networkManager: any NetworkManagerProtocol
    private let state: AppStateClass
    
    init(networkManager: any NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        self.state = AppStateClass()
    }
    
    func onAppear() {
        Task {
            await handleAppearance()
        }
    }
}

private extension InitialManager {
    func handleAppearance() async {
        if networkManager.provenURL != nil {
            transition(to: .initial)
            return
        }
        
        do {
            let hasValidURL = try await networkManager.checkURL()
            transition(to: hasValidURL ? .initial : .root)
        } catch {
            transition(to: .root)
        }
    }
    
    func transition(to newState: AppState) {
        state.transition(to: newState) { [weak self] state in
            self?.appState = state
        }
    }
}

private final class AppStateClass {
    private(set) var currentState: AppState = .loading
    
    func transition(to newState: AppState, completion: @escaping (AppState) -> Void) {
        let validTransition = getTransition(from: currentState, to: newState)
        guard validTransition else { return }
        
        currentState = newState
        completion(newState)
    }
    
    private func getTransition(from currentState: AppState, to newState: AppState) -> Bool {
        switch (currentState, newState) {
        case (.loading, _):
            return true
        case (.initial, .root):
            return true
        case (.root, .initial):
            return true
        default:
            return false
        }
    }
}
