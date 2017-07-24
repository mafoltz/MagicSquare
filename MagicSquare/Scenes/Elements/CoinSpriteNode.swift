//
//  CoinSpriteNode.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 24/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class CoinSpriteNode: SKSpriteNode {
    
    // MARK: - Methods
    
    func setCoinForRecord(from level: Level) {
        switch level.getCoinForRecord() {
        case .undone:
            texture = SKTexture(imageNamed: "undoneLevel")
            
        case .golden:
            texture = SKTexture(imageNamed: "goldenLevel")
            
        case .silver:
            texture = SKTexture(imageNamed: "silverLevel")
            
        case .bronze:
            texture = SKTexture(imageNamed: "bronzeLevel")
            
        default:
            texture = SKTexture(imageNamed: "lockedLevel")
        }
    }
    
    func setCoinForCurrentGame(from level: Level) {
        switch level.getCoinForCurrentGame() {
        case .undone:
            texture = SKTexture(imageNamed: "undoneLevel")
            
        case .golden:
            texture = SKTexture(imageNamed: "goldenLevel")
            
        case .silver:
            texture = SKTexture(imageNamed: "silverLevel")
            
        case .bronze:
            texture = SKTexture(imageNamed: "bronzeLevel")
            
        default:
            texture = SKTexture(imageNamed: "lockedLevel")
        }
    }
}
