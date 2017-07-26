//
//  BoardCellSpriteNode.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 26/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class BoardCellSpriteNode: SKShapeNode {
    
    // MARK: - Properties
    
    private var borderNode: SKShapeNode!
    private var isBlinking = false
    
    // MARK: - Methods
    
    func blinkColor() {
        if !isBlinking {
            isBlinking = true
            
            borderNode = self.copy() as! SKShapeNode
            borderNode.xScale = 1.2
            borderNode.yScale = 1.2
            borderNode.zPosition -= 0.1
            
            borderNode.position = CGPoint(x: 0.0, y: 0.0)
            borderNode.run(SKAction.fadeOut(withDuration: 0.0))
            
            let fadeTime = 0.5
            
            let fadeAlpha = SKAction.fadeAlpha(to: 0.5, duration: fadeTime)
            fadeAlpha.timingMode = .easeInEaseOut
            
            let fadeIn = SKAction.fadeIn(withDuration: fadeTime)
            fadeIn.timingMode = .easeInEaseOut
            
            let fadeOut = SKAction.fadeOut(withDuration: fadeTime)
            fadeOut.timingMode = .easeInEaseOut
            
            let sequence = SKAction.sequence([fadeIn, fadeOut, fadeIn, fadeOut])
            
            borderNode.run(sequence, withKey: "blink")
            addChild(borderNode)
        }
    }
    
    func stopBlinkColor() {
        if isBlinking {
            borderNode.removeAllActions()
            removeAllChildren()
            isBlinking = false
        }
    }
}
