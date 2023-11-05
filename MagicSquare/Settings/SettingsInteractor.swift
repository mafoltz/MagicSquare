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
    case about

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
        case .about:
            return "About Us"
        }
    }

    func imageName(isOn: Bool) -> String {
        switch self {
        case .sfx:
            return isOn ? "speaker.wave.1" : "speaker.slash"
        case .music:
            return isOn ? "speaker.wave.1" : "speaker.slash"
        case .colorblind:
            return isOn ? "eye" : "eye.slash"
        case .haptics:
            return isOn ? "iphone" : "iphone.slash"
        case .about:
            return "person.3.sequence.fill"
        }
    }
}

class SettingsInteractor {

    private weak var viewController: SettingsViewController?

    typealias Section = (title: String, elements: [Settings])

    var settings: [Settings: Bool]
    var sections: [Section]

    init(viewController: SettingsViewController) {
        self.viewController = viewController
        settings = [:]

        var settingsElements: [Settings] = []
        var aboutElements: [Settings] = []

        for setting in Settings.allCases {
            switch setting {
            case .music:
                settings[.music] = SettingsManager.shared.isMusicEnabled
                settingsElements.append(.music)
            case .sfx:
                settings[.sfx] = SettingsManager.shared.isSFXEnabled
                settingsElements.append(.sfx)
            case .colorblind:
                settings[.colorblind] = SettingsManager.shared.isColorblindEnabled
                settingsElements.append(.colorblind)
            case .haptics:
                settings[.haptics] = SettingsManager.shared.isHapticsEnabled
                settingsElements.append(.haptics)
            case .about:
                settings[.about] = true
                aboutElements.append(.about)
            }
        }

        sections = [
            (title: "Game Settings", elements: settingsElements),
            (title: "About", elements: aboutElements)
        ]
    }

    func didSelectRow(at indexPath: IndexPath) {
        let selectedSetting = sections[indexPath.section].elements[indexPath.row]
        settings[selectedSetting]?.toggle()
        let newConfiguration = settings[selectedSetting] ?? false

        switch selectedSetting {
        case .sfx:
            SettingsManager.shared.setConfig(newConfiguration, forKey: .sfx)
        case .music:
            SettingsManager.shared.setConfig(newConfiguration, forKey: .music)

            if SettingsManager.shared.isMusicEnabled {
                MusicController.sharedInstance.play(music: "Esles_Main_Theme", type: "mp3")
            } else {
                MusicController.sharedInstance.stop()
            }

        case .colorblind:
            SettingsManager.shared.setConfig(newConfiguration, forKey: .colorBlind)
        case .haptics:
            SettingsManager.shared.setConfig(newConfiguration, forKey: .haptics)
            if newConfiguration {
                HapticsController.shared?.hapticBlink()
            }
        case .about:
            viewController?.routeToAbout()
            return
        }

        viewController?.updateSettings(at: [indexPath])
    }
}
