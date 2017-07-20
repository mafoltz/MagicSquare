//
//  TemplateBoard.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 19/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class TemplateBoard: SKSpriteNode {
    
    private var templateBaloon = SKShapeNode()
    private var templateBoard : [[SKShapeNode]]!
    
    private var baloonSize : CGSize!
    private var bottomSpacing : CGFloat!
    private let cornerRadius: CGFloat = 30
    
    func setTemplate(from currentLevel: Level, view: SKView) {
        isUserInteractionEnabled = true
        isHidden = true
        anchorPoint = (view.scene?.anchorPoint)!
        zPosition = 2.0
        
        bottomSpacing = 0.045 * view.bounds.size.height
        
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.35)
        let backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.run(SKAction.moveBy(x: 0.0, y: view.bounds.size.height / 2, duration: 0.0))
        backgroundScreen.zPosition = 0.1
        addChild(backgroundScreen)
        
        let roundedRect = CGRect(x: (bottomSpacing - view.bounds.size.width) / 2,
                                 y: (bottomSpacing / 2),
                                 width: view.bounds.size.width - bottomSpacing,
                                 height: 0.65 * view.bounds.size.height)
        baloonSize = roundedRect.size
        templateBaloon.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        templateBaloon.fillColor = UIColor.white
        templateBaloon.zPosition = 0.2
        addChild(templateBaloon)
    }
    
    func show() {
        isUserInteractionEnabled = false
        isHidden = false
        
        let speed = 0.3
        
        let moveUp = SKAction.moveBy(x: 0.0, y: baloonSize.height, duration: 0.0)
        let moveDown = SKAction.moveBy(x: 0.0, y: -baloonSize.height, duration: speed)
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        
        let decrease = SKAction.scale(to: 0.0, duration: 0.0)
        let growUp = SKAction.scale(to: baloonSize, duration: speed)
        let actionsSequence = SKAction.sequence([decrease, growUp])
        
        let actionsGroup = SKAction.group([moveSequence, actionsSequence])
        
        templateBaloon.run(actionsGroup)
        
        Timer.scheduledTimer(timeInterval: speed + 0.1, target: self, selector: #selector(self.setUserInteractionEnabled), userInfo: nil, repeats: false)
    }
    
    func hide() {
        isUserInteractionEnabled = false
        
        let speed = 0.3
        
        let moveUp = SKAction.moveBy(x: 0.0, y: baloonSize.height, duration: speed)
        let moveDown = SKAction.moveBy(x: 0.0, y: -baloonSize.height, duration: 0.0)
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        
        let growUp = SKAction.scale(to: baloonSize, duration: 0.0)
        let decrease = SKAction.scale(to: 0.0, duration: 0.3)
        let actionsSequence = SKAction.sequence([growUp, decrease])
        
        let actionsGroup = SKAction.group([moveSequence, actionsSequence])
        
        templateBaloon.run(actionsGroup)
        
        Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(self.setHidden), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: speed + 0.1, target: self, selector: #selector(self.setUserInteractionEnabled), userInfo: nil, repeats: false)
    }
    
    func setHidden() {
        isHidden = true
    }
    
    func setUserInteractionEnabled() {
        isUserInteractionEnabled = true
    }
}
