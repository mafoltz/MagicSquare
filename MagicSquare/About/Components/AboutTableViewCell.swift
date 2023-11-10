//
//  AboutTableViewCell.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 04/11/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {

    static let identifier = "AboutTableViewCell"

    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!


    func configure(teamMember: AboutViewModel.TeamMember) {
        primaryLabel.text = teamMember.name
        secondaryLabel.text = teamMember.role
    }
}
