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
    var row: Int!
    var column: Int!
    let color: UIColor!
    let spriteNode: SKSpriteNode!
    
    init(row: Int, column: Int, color: UIColor, size: CGSize, position: CGPoint) {
        self.row = row
        self.column = column
        self.color = color
        self.spriteNode = SKSpriteNode(color: color, size: size)
        self.spriteNode.position = position
        self.spriteNode.anchorPoint = CGPoint(x: 0, y: 0)
    }
	
	func getSpriteNode() -> SKShapeNode {
		
		let square = SKShapeNode(rectOf: CGSize(width: 20, height: 20), cornerRadius: 4.0)
		square.fillColor = self.color
		square.strokeColor = UIColor.black
		
		return square
	}

}
