//
//  SettingsInteractor.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 22/10/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import Foundation

enum Settings: CaseIterable {
    case sfx
    case music
    case colorblind
    case haptics

    var title: String {
        switch self {
        case .sfx:
            return "Sound Effects"
        case .music:
            return "Music"
        case .colorblind:
            return "Colorblind"
        case .haptics:
            return "Haptics"
        }
    }

    func imageName(isOn: Bool) -> String {
        switch self {
        case .sfx:
            return isOn ? "speaker" : "speaker.slash"
        case .music:
            return isOn ? "speaker" : "speaker.slash"
        case .colorblind:
            return isOn ? "eye" : "eye.slash"
        case .haptics:
            return isOn ? "iphone.homebutton.radiowaves.left.and.right" : "iphone"
        }
    }
}

class SettingsInteractor {

    private weak var viewController: SettingsViewController?

    var settings: [Settings: Bool]
    var sectionElements: [Settings]

    init(viewController: SettingsViewController) {
        self.viewController = viewController
        settings = [:]
        sectionElements = []

        for setting in Settings.allCases {
            switch setting {
            case .music:
                settings[.music] = SettingsManager.shared.isMusicEnabled
                sectionElements.append(.music)
            case .sfx:
                settings[.sfx] = SettingsManager.shared.isSFXEnabled
                sectionElements.append(.sfx)
            case .colorblind:
                settings[.colorblind] = SettingsManager.shared.isColorblindEnabled
                sectionElements.append(.colorblind)
            case .haptics:
                settings[.haptics] = SettingsManager.shared.isHapticsEnabled
                sectionElements.append(.haptics)
            }
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        let selectedSetting = sectionElements[indexPath.row]
        settings[selectedSetting]?.toggle()
        let newConfiguration = settings[selectedSetting] ?? false

        switch selectedSetting {
        case .sfx:
            SettingsManager.shared.setConfig(newConfiguration, forKey: .sfx)
        case .music:
            SettingsManager.shared.setConfig(newConfiguration, forKey: .music)
        case .colorblind:
            SettingsManager.shared.setConfig(newConfiguration, forKey: .colorBlind)
        case .haptics:
            SettingsManager.shared.setConfig(newConfiguration, forKey: .haptics)
            if newConfiguration {
                HapticsController.shared?.hapticBlink()
            }
        }

        viewController?.updateSettings(at: [indexPath])
    }
}
