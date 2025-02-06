//
//  OptionsView.swift
//  Pechanga
//
//  Created by J on 06.02.2025.
//

import SwiftUI

struct OptionsView: View {
    @StateObject private var gameManager = GameManager.shared
    @StateObject private var settingsState = SettingsState.shared
    
    private let shareService = AppShareService.shared
    
    var body: some View {
        ZStack {
            Backgr()
            
            BackButton()
                .padding()
            
            Rectngl(width: 300, height: 350)
                .overlay {
                    VStack(spacing: 20) {
                        Text("OPTIONS")
                            .foregroundStyle(.milkcoffee)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        
                        VStack(spacing: 20) {
                            toggleButton(
                                title: "MUSIC",
                                isEnabled: settingsState.isMusicEnabled
                            ) {
                                settingsState.isMusicEnabled.toggle()
                            }
                            
                            toggleButton(
                                title: "VIBRATION",
                                isEnabled: settingsState.isVibrationEnabled
                            ) {
                                settingsState.isVibrationEnabled.toggle()
                            }
                        }
                        
                        HStack {
                            Button {
                                shareService.shareApp()
                            } label: {
                                CapsuleButton(text: "SHARE", width: 110, height: 32)
                            }
                            .buttonStyle(.plain)
                            
                            Button {
                                shareService.rateApp()
                            } label: {
                                CapsuleButton(text: "RATE US", width: 110, height: 32)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func toggleButton(
        title: String,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .foregroundStyle(.milkcoffee)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            HStack {
                Text("OFF")
                    .foregroundStyle(.milkcoffee)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        action()
                    }
                } label: {
                    CapsuleButton(text: "", width: 110, height: 44)
                        .overlay(alignment: isEnabled ? .trailing : .leading) {
                            Capsule()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(isEnabled ? Color.green.opacity(0.5) : Color.red.opacity(0.5))
                                .overlay {
                                    Capsule()
                                        .stroke(Color.black, lineWidth: 1)
                                }
                        }
                }
                .buttonStyle(.plain)
                
                Text("ON")
                    .foregroundStyle(.milkcoffee)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
        }
    }
}

#Preview {
    OptionsView()
}
