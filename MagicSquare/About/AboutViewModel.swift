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

    let headerNote: String = "Made by"
    let footNote: String = "© 2017 Esle Inc. All rights reserved. 🇧🇷"

    enum TeamMember: CaseIterable {
        case arthur, athos, eduardo, luisa, marcelo

        var name: String {
            switch self {
            case .arthur:
                return "Arthur Giachini"
            case .athos:
                return "Athos Lagemann"
            case .eduardo:
                return "Eduardo Fornari"
            case .luisa:
                return "Luisa Scaletsky"
            case .marcelo:
                return "Marcelo Foltz"
            }
        }

        var role: String {
            switch self {
            case .luisa:
                return "Designer"
            default:
                return "Developer"
            }
        }
    }

    mutating func addTeamMember() -> IndexPath? {
        guard let newTeamMember = TeamMember.allCases[safe: teamMembers.count] else { return nil }
        teamMembers.append(newTeamMember)
        return IndexPath(row: teamMembers.count, section: 0)
    }
}
