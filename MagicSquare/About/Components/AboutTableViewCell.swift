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

    @IBOutlet private weak var aboutImageView: UIImageView?

    func configure(teamMember: AboutViewModel.TeamMember) {
        aboutImageView?.image = UIImage(named: teamMember.imageTitle)
    }
}
