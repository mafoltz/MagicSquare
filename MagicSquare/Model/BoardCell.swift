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
    let color: UIColor!
    
    init(color: UIColor) {
        self.color = color
    }
	
	func getSpriteNode() -> SKShapeNode {
		
		let square = SKShapeNode(rectOf: CGSize(width: 20, height: 20), cornerRadius: 4.0)
		square.fillColor = self.color
		square.strokeColor = UIColor.black
		
		return square
	}

}
