//
//  Hud.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 19/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class Hud: SKSpriteNode {
    
    // MARK: - Properties
    
    private var esleButton: SKSpriteNode!
    private var levelsButton: SKSpriteNode!
    private var configurationsButton: SKSpriteNode!
    public var movesLabel: SKLabelNode!
	private var levelLabel: SKLabelNode!
	var parentHeight: CGFloat!
	
    private var buttonWidthDistance: CGFloat!
    private var buttonsLineHeight: CGFloat!
    
    var actionDelegate: ActionHandlerDelegate?
    
    private var quoteLabel: Label!
	private var fontSize: CGFloat!
    
    // MARK: - Methods
    
    func setHud(from currentLevel: Level) {
        isUserInteractionEnabled = true
        zPosition = 1.0
        name = "hud"
		
		if parentHeight != nil {
			fontSize = getFontSize(fontSize: 18, screenHeight: parentHeight)
		} else {
			fontSize = getFontSize(fontSize: 18, screenHeight: self.size.height * 3.6)
		}
		
        buttonWidthDistance = 0.372 * self.size.width
        buttonsLineHeight = 0.2 * self.size.height
        
        esleButton = SKSpriteNode(imageNamed: "mascot")
        esleButton.size = CGSize(width: 0.63 * self.size.height, height: 0.95 * self.size.height)
        esleButton.run(SKAction.moveBy(x: 0.0, y: -0.3 * buttonsLineHeight, duration: 0.0))
        esleButton.zPosition = 2.0
        addChild(esleButton)
        
        let moveDown = SKAction.moveBy(x: 0.0, y: -10.0, duration: 0.5)
        moveDown.timingMode = .easeInEaseOut
        let moveUp = SKAction.moveBy(x: 0.0, y: 10.0, duration: 0.4)
        moveUp.timingMode = .easeInEaseOut
        let sequence = SKAction.sequence([moveDown, moveUp])
        esleButton.run(SKAction.repeatForever(sequence), withKey: "eslesMovement")
        
        levelsButton = SKSpriteNode(imageNamed: "levelsButton")
        levelsButton.size = CGSize(width: self.size.height / 3, height: self.size.height / 3)
        levelsButton.run(SKAction.moveBy(x: -buttonWidthDistance, y: buttonsLineHeight, duration: 0.0))
        levelsButton.zPosition = 0.1
        addChild(levelsButton)
        
        configurationsButton = SKSpriteNode(imageNamed: "config")
        configurationsButton.size = CGSize(width: self.size.height / 3, height: self.size.height / 3)
        configurationsButton.run(SKAction.moveBy(x: buttonWidthDistance, y: buttonsLineHeight, duration: 0.0))
        configurationsButton.zPosition = 0.1
        addChild(configurationsButton)
        
        let levelTitleLabel = SKLabelNode(text: "LEVEL")
        levelTitleLabel.fontColor = UIColor.white
        levelTitleLabel.fontName = ".SFUIText-Medium"
        levelTitleLabel.fontSize = fontSize
        levelTitleLabel.run(SKAction.moveBy(x: -buttonWidthDistance, y: -buttonsLineHeight, duration: 0.0))
        levelTitleLabel.zPosition = 0.1
        addChild(levelTitleLabel)
        
        levelLabel = SKLabelNode(text: String(currentLevel.number))
        levelLabel.fontColor = UIColor.white
        levelLabel.fontName = ".SFUIText-Heavy"
        levelLabel.fontSize = fontSize
        levelLabel.run(SKAction.moveBy(x: -buttonWidthDistance, y: -1.8 * buttonsLineHeight, duration: 0.0))
        levelLabel.zPosition = 0.1
        addChild(levelLabel)
        
        let movesTitleLabel = SKLabelNode(text: "MOVES")
        movesTitleLabel.fontColor = UIColor.white
        movesTitleLabel.fontName = ".SFUIText-Medium"
        movesTitleLabel.fontSize = fontSize
        movesTitleLabel.run(SKAction.moveBy(x: buttonWidthDistance, y: -buttonsLineHeight, duration: 0.0))
        movesTitleLabel.zPosition = 0.1
        addChild(movesTitleLabel)
        
        movesLabel = SKLabelNode(text: String(currentLevel.playerMoves))
        movesLabel.fontColor = UIColor.white
        movesLabel.fontName = ".SFUIText-Heavy"
        movesLabel.fontSize = fontSize
        movesLabel.run(SKAction.moveBy(x: buttonWidthDistance, y: -1.8 * buttonsLineHeight, duration: 0.0))
        movesLabel.zPosition = 0.1
        addChild(movesLabel)
    }
    
    func resetEslePosition() {
        esleButton.removeAction(forKey: "eslesMovement")
        esleButton.run(SKAction.moveTo(y: -0.3 * buttonsLineHeight, duration: 0.4))
    }
    
    func setQuoteLabel(with text: String) {
        if quoteLabel != nil {
            removeChildren(in: [quoteLabel])
        }
        
        let fontColor = UIColor(red: 47/256, green: 66/256, blue: 67/256, alpha: 1.0)
        quoteLabel = Label(text: text, fontName: ".SFUIText-Medium", fontSize: fontSize, width: size.width*0.808, fontColor: fontColor)
		
        quoteLabel.position = CGPoint(x: 0.0, y: -((size.height*0.5) + (size.height*0.33)))
        quoteLabel.zPosition = 0.1
        addChild(quoteLabel)
        animatePopLabel(quoteLabel)
    }
    
    func animatePopLabel(_ label: SKNode) {
        let grow = SKAction.scale(by: 1.15, duration: 0.3)
        let shrink = SKAction.scale(to: 1.0, duration: 0.3)
        let wait = SKAction.wait(forDuration: 0.15)
        let waitClose = SKAction.wait(forDuration: 0.4)
        
        let sequence = SKAction.sequence([waitClose, grow, wait, shrink])
        let repeatSequence = SKAction.repeat(sequence, count: 2)
        label.run(repeatSequence)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first?.location(in: self)
        
        if esleButton.contains(touchLocation!) {
            actionDelegate?.answerAction()
        }
        
        else if levelsButton.contains(touchLocation!) {
            actionDelegate?.levelsAction()
        }
		
		else if configurationsButton.contains(touchLocation!) {
			actionDelegate?.configurationsAction()
		}
    }
}
