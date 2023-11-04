//
//  HapticsController.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 05/10/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import CoreHaptics

class HapticsController {

    // MARK: Private Properties

    private let hapticEngine: CHHapticEngine
    private var hapticsEnabled: Bool { SettingsManager.shared.isHapticsEnabled }

    // MARK: Inits & Singleton

    private init?() {
        guard SettingsManager.shared.supportsHaptics else { return nil }

        do {
            hapticEngine = try CHHapticEngine()
            hapticEngine.playsHapticsOnly = true
        } catch {
            print("[Haptics] Haptic Engine creation error: \(error.localizedDescription)")
            return nil
        }
    }

    static var shared: HapticsController? = HapticsController()

    // MARK: Public Methods

    func hapticBlink() {
        guard hapticsEnabled else { return }
        if let pattern = try? blinkPattern() {
            playPattern(pattern)
        }
    }

    func hapticVictory() {
        guard hapticsEnabled else { return }
        if let pattern = try? victoryPattern() {
            playPattern(pattern)
        }
    }

    // MARK: Private Methods

    private func playPattern(_ pattern: CHHapticPattern) {
        do {
            try hapticEngine.start()
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            hapticEngine.notifyWhenPlayersFinished { _ in
                return .stopEngine
            }

        } catch {
            print("[Haptics] Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }

    private func blinkPattern() throws -> CHHapticPattern {
        let snip = CHHapticEvent(eventType: .hapticTransient,
                                 parameters: [
                                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                                 ],
                                 relativeTime: 0)

        return try CHHapticPattern(events: [snip], parameters: [])
    }

    private func victoryPattern() throws -> CHHapticPattern {
        let step1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.75),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.75)
            ],
            relativeTime: 0)

        let step2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: 0.2)

        return try CHHapticPattern(events: [step1, step2], parameters: [])
    }
}
