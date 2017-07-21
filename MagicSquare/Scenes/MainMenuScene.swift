//
//  MainMenuScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    // MARK: - Properties
    
    private var backgroundColorNode: SKSpriteNode!
    private var titleLabelNode: SKLabelNode!
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        backgroundColorNode = SKSpriteNode(color: UIColor.cyan, size: view.bounds.size)
        backgroundColorNode.name = "Background Color"
        backgroundColorNode.zPosition = 1.1
        addChild(backgroundColorNode)
        
        titleLabelNode = SKLabelNode(text: "TAP TO BEGIN!")
        titleLabelNode.fontColor = UIColor.black
        titleLabelNode.fontName = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize).fontName
        titleLabelNode.zPosition = 1.2
        let increaseScale = SKAction.scale(by: 1.1, duration: 0.5)
        let decreaseScale = SKAction.scale(to: 1, duration: 0.5)
        let animation = SKAction.repeatForever(SKAction.sequence([increaseScale, decreaseScale]))
        titleLabelNode.run(animation)
        addChild(titleLabelNode)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene: LevelsScene = LevelsScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.prepareScene(from: self.scene!)
        super.view?.presentScene(scene)
    }
}
