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
    
    private var templateBoard : [[SKShapeNode]]!
    
    private var bottomSpacing : CGFloat!
    private let cornerRadius: CGFloat = 30
    
    func setTemplate(from currentLevel: Level, view: SKView) {
        isHidden = true
        anchorPoint = (view.scene?.anchorPoint)!
        zPosition = 2.0
        
        bottomSpacing = 0.045 * view.bounds.size.height
        
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.35)
        let backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.zPosition = 0.1
        addChild(backgroundScreen)
        
        let roundedRect = CGRect(x: (bottomSpacing - view.bounds.size.width) / 2,
                                 y: (bottomSpacing / 2),
                                 width: view.bounds.size.width - bottomSpacing,
                                 height: view.bounds.size.height)
        let templateBaloon = SKShapeNode()
        templateBaloon.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        templateBaloon.fillColor = UIColor.white
        templateBaloon.zPosition = 0.2
        addChild(templateBaloon)
    }
}
