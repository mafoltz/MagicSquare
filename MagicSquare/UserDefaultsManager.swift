//
//  UserDefaultsManager.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 04/10/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import Foundation

class UserDefaultsManager {

    // MARK: Keys

    enum Key: String {
        // World / Level elements
        case world, level

        // SFX Elements
        case music, sfx

        // Visuals
        case colorBlind
    }

    // MARK: Singleton Configuration

    private init() { /* no-op */ }

    static var shared: UserDefaultsManager = UserDefaultsManager()

    // MARK: Public Getters

    // Game Elements

    var currentWorld: String? {
        return stringForKey(.world)
    }

    var currentLevel: Int {
        return intForKey(.level)
    }

    // SFX Elements

    var isSFXEnabled: Bool {
        return boolForKey(.sfx)
    }

    var isMusicEnabled: Bool {
        return boolForKey(.music)
    }

    // Visual Elements

    var isColorblindEnabled: Bool {
        return boolForKey(.colorBlind)
    }

    // MARK: Public Setters

    func saveCurrentLevel(_ level: Int, world: String) {
        setValueForKey(.level, value: level)
        setValueForKey(.world, value: world)
    }

    func setConfig<T>(_ value: T, forKey key: Key) {
        setValueForKey(key, value: value)
    }
}

// MARK: Private Utility Methods

extension UserDefaultsManager {

    private func boolForKey(_ key: Key) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }

    private func stringForKey(_ key: Key) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }

    private func intForKey(_ key: Key) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }

    private func setValueForKey<T>(_ key: Key, value: T) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}
