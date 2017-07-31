//
//  BoardCell.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit
import SpriteKit

class BoardCell {
    
    // MARK: - Properties
    
    let color: UIColor!
	let symbol: String!
	
    // MARK: - Methods
    
	init(color: UIColor, colorSymbol: Int) {
        self.color = color
		self.symbol = String("cell" + colorSymbol.description)
    }
}
