//
//  AboutViewModel.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 04/11/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import Foundation

struct AboutViewModel {

    var teamMembers: [TeamMember] = TeamMember.allCases

    let headerNote: String = "Made with ❤️ in 🇧🇷"
    let footNote: String = "© 2017 Esle Inc. All rights reserved."

    enum TeamMember: CaseIterable {
        case arthur, athos, eduardo, luisa, marcelo

        var imageTitle: String {
            switch self {
            case .arthur:
                return "Arthur"
            case .athos:
                return "Athos"
            case .eduardo:
                return "Eduardo"
            case .luisa:
                return "Luisa"
            case .marcelo:
                return "Marcelo"
            }
        }
    }

    mutating func addTeamMember() -> IndexPath? {
        guard let newTeamMember = TeamMember.allCases[safe: teamMembers.count] else { return nil }
        teamMembers.append(newTeamMember)
        return IndexPath(row: teamMembers.count, section: 0)
    }
}
