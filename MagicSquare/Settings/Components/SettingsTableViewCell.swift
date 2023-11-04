//
//  SettingsTableViewCell.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 22/10/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet private weak var settingImageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?

    static let Identifier = "SettingsTableViewCell"

    func configure(setting: Settings, isOn: Bool) {
        titleLabel?.text = setting.title
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

        let tintColor = isOn ? UIColor.systemTeal : .systemGray
        settingImageView?.image = UIImage(systemName: setting.imageName(isOn: isOn))
        settingImageView?.tintColor = tintColor

        selectionStyle = .none
    }

}
