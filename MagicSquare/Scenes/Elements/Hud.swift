//
//  Hud.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 19/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class Hud: SKSpriteNode {
    
    public var templateButton : SKSpriteNode!
    public var levelsButton : SKSpriteNode!
    public var hintButton : SKSpriteNode!
    public var movesLabel : SKLabelNode!
    public var levelLabel : SKLabelNode!
    
    private var buttonWidthDistance : CGFloat!
    private var buttonsLineHeight : CGFloat!
    
    func setHud(from currentLevel: Level, view: SKView) {
        zPosition = 1.0
        
        buttonWidthDistance = 0.372 * self.size.width
        buttonsLineHeight = 0.2 * self.size.height
        
        templateButton = SKSpriteNode(imageNamed: "mascot")
        templateButton.run(SKAction.moveBy(x: 0.0, y: -buttonsLineHeight / 2, duration: 0.0))
        templateButton.zPosition = 0.1
        addChild(templateButton)
        
        let moveUp = SKAction.moveBy(x: 0.0, y: 10.0, duration: 0.4)
        let moveDown = SKAction.moveBy(x: 0.0, y: -10.0, duration: 0.5)
        let sequence = SKAction.sequence([moveUp, moveDown])
        templateButton.run(SKAction.repeatForever(sequence))
        
        levelsButton = SKSpriteNode(imageNamed: "levelsButton")
        levelsButton.size = CGSize(width: self.size.height / 3, height: self.size.height / 3)
        levelsButton.run(SKAction.moveBy(x: -buttonWidthDistance, y: buttonsLineHeight, duration: 0.0))
        levelsButton.zPosition = 0.1
        addChild(levelsButton)
        
        hintButton = SKSpriteNode(imageNamed: "hintButton")
        hintButton.size = CGSize(width: self.size.height / 3, height: self.size.height / 3)
        hintButton.run(SKAction.moveBy(x: buttonWidthDistance, y: buttonsLineHeight, duration: 0.0))
        hintButton.zPosition = 0.1
        addChild(hintButton)
        
        let movesTitleLabel = SKLabelNode(text: "MOVES")
        movesTitleLabel.fontColor = UIColor.white
        movesTitleLabel.fontName = UIFont(name: ".SFUIText-Medium", size: 18.0)?.fontName
        movesTitleLabel.fontSize = 18.0
        movesTitleLabel.run(SKAction.moveBy(x: -buttonWidthDistance, y: -buttonsLineHeight, duration: 0.0))
        movesTitleLabel.zPosition = 0.1
        addChild(movesTitleLabel)
        
        let levelTitleLabel = SKLabelNode(text: "LEVEL")
        levelTitleLabel.fontColor = UIColor.white
        levelTitleLabel.fontName = UIFont(name: ".SFUIText-Medium", size: 18.0)?.fontName
        levelTitleLabel.fontSize = 18.0
        levelTitleLabel.run(SKAction.moveBy(x: buttonWidthDistance, y: -buttonsLineHeight, duration: 0.0))
        levelTitleLabel.zPosition = 0.1
        addChild(levelTitleLabel)
        
        movesLabel = SKLabelNode(text: String(currentLevel.playerMoves))
        movesLabel.fontColor = UIColor.white
        movesLabel.fontName = UIFont(name: ".SFUIText-Heavy", size: 18.0)?.fontName
        movesLabel.fontSize = 18.0
        movesLabel.run(SKAction.moveBy(x: -buttonWidthDistance, y: -1.8 * buttonsLineHeight, duration: 0.0))
        movesLabel.zPosition = 0.1
        addChild(movesLabel)
        
        levelLabel = SKLabelNode(text: String(currentLevel.number))
        levelLabel.fontColor = UIColor.white
        levelLabel.fontName = UIFont(name: ".SFUIText-Heavy", size: 18.0)?.fontName
        levelLabel.fontSize = 18.0
        levelLabel.run(SKAction.moveBy(x: buttonWidthDistance, y: -1.8 * buttonsLineHeight, duration: 0.0))
        levelLabel.zPosition = 0.1
        addChild(levelLabel)
    }
}
