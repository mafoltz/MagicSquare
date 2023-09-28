//
//  BoardCellShapeNode.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 26/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class BoardCellShapeNode: SKShapeNode {
    
    // MARK: - Properties
    
    private var borderNode: SKShapeNode?
    
    // MARK: - Methods
    
    func blinkColor() {
        guard let borderNode = self.copy() as? SKShapeNode else { return }
        self.borderNode = borderNode

		borderNode.xScale = 1.1
		borderNode.yScale = 1.1
		borderNode.zPosition -= 0.1
		
		borderNode.position = CGPoint(x: 0.0, y: 0.0)
		borderNode.run(SKAction.fadeOut(withDuration: 0.0))
		
		let fadeTime = 0.3
		
		let fadeAlpha = SKAction.fadeAlpha(to: 0.5, duration: fadeTime)
		fadeAlpha.timingMode = .easeInEaseOut
		
		let fadeIn = SKAction.fadeIn(withDuration: fadeTime)
		fadeIn.timingMode = .easeInEaseOut
		
		let fadeOut = SKAction.fadeOut(withDuration: fadeTime)
		fadeOut.timingMode = .easeInEaseOut
		
		let sequence = SKAction.sequence([fadeAlpha, fadeOut])
		
		borderNode.run(sequence, completion: {
			self.borderNode?.removeFromParent()
		})

		addChild(borderNode)
    }
}
