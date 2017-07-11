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
}
