//
//  SettingsManager.swift
//  Pechanga
//
//  Created by Alex on 06.02.2025.
//

import UIKit
import AVFoundation

final class SettingsManager {
    static let shared = SettingsManager()
    
    private enum Keys: String {
        case musicEnabled
        case vibrationEnabled
    }
    
    private let defaults = UserDefaults.standard
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private var audioPlayer: AVAudioPlayer?
    
    var isMusicEnabled: Bool {
        get { defaults.bool(forKey: Keys.musicEnabled.rawValue) }
        set {
            defaults.set(newValue, forKey: Keys.musicEnabled.rawValue)
            if newValue {
                playBackgroundMusic()
            } else {
                stopBackgroundMusic()
            }
        }
    }
    
    var isVibrationEnabled: Bool {
        get { defaults.bool(forKey: Keys.vibrationEnabled.rawValue) }
        set { defaults.set(newValue, forKey: Keys.vibrationEnabled.rawValue) }
    }
    
    // MARK: - Initialization
    private init() {
        setupDefaultSettings()
        setupAudioSession()
        prepareHaptics()
        prepareBackgroundMusic()
    }
    
    // MARK: - Public Methods
    func vibrate() {
        guard isVibrationEnabled else { return }
        lightGenerator.impactOccurred()
    }
    
    func toggleMusic() {
        isMusicEnabled.toggle()
    }
    
    func playBackgroundMusic() {
        guard isMusicEnabled,
              let player = audioPlayer,
              !player.isPlaying else { return }
        
        audioPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.pause()
    }
    
    // MARK: - Private Methods
    private func setupDefaultSettings() {
        if defaults.object(forKey: Keys.musicEnabled.rawValue) == nil {
            defaults.set(true, forKey: Keys.musicEnabled.rawValue)
        }
        if defaults.object(forKey: Keys.vibrationEnabled.rawValue) == nil {
            defaults.set(true, forKey: Keys.vibrationEnabled.rawValue)
        }
    }
    
    private func prepareHaptics() {
        lightGenerator.prepare()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func prepareBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
        } catch {
            print(error)
        }
    }
}

// MARK: - SettingsState
@MainActor
final class SettingsState: ObservableObject {
    static let shared = SettingsState()
    
    @Published var isMusicEnabled: Bool {
        didSet {
            settings.isMusicEnabled = isMusicEnabled
        }
    }
    
    @Published var isVibrationEnabled: Bool {
        didSet {
            settings.isVibrationEnabled = isVibrationEnabled
        }
    }
    
    private let settings = SettingsManager.shared
    
    private init() {
        self.isMusicEnabled = settings.isMusicEnabled
        self.isVibrationEnabled = settings.isVibrationEnabled
    }
}
