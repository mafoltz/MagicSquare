//
//  Font+Extensions.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 02/11/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import UIKit

extension SKLabelNode {

    func text(_ text: String, style: UIFont.TextStyle, color: UIColor) {
        self.attributedText = NSAttributedString(string: text, 
                                                 attributes:
                                                    [
                                                        .font: UIFont.preferredFont(forTextStyle: style),
                                                        .foregroundColor: color
                                                    ])
    }

    func updateText(_ newText: String) {
        guard let previousText = self.attributedText else { return }
        self.attributedText = NSAttributedString(string: newText, attributes: previousText.attributes(at: 0, effectiveRange: nil))
    }
}
