//
//  LevelsScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelsScene: SKScene {
    var previousSceneChildren: SKSpriteNode!
    var backgroundScreen: SKSpriteNode!
    var levelsScreen: SKShapeNode!
    
    let verticalSpacing: CGFloat = 67
    let horizontalSpacing: CGFloat = 50
    let cornerRadius: CGFloat = 30
    
    func prepareScene(from previousScene: SKScene) {
        previousSceneChildren = SKSpriteNode(color: UIColor.white, size: (previousScene.view?.bounds.size)!)
        previousScene.zPosition = 0
        
        for child in previousScene.children {
            child.removeFromParent()
            previousSceneChildren.addChild(child)
        }
        
        addChild(previousSceneChildren)
    }
    
    override func didMove(to view: SKView) {
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.35)
        backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.zPosition = 1
        addChild(backgroundScreen)
        
        let roundedRect = CGRect(x: horizontalSpacing - (view.bounds.size.width / 2),
                                 y: verticalSpacing - (view.bounds.size.height / 2),
                                 width: view.bounds.size.width,
                                 height: view.bounds.size.height - 2 * verticalSpacing)
        levelsScreen = SKShapeNode()
        levelsScreen.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        levelsScreen.fillColor = UIColor.white
        levelsScreen.zPosition = 2
        addChild(levelsScreen)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !levelsScreen.contains(touch.location(in: self)) {
                backToMainMenuScene()
            }
        }
    }
    
    func backToMainMenuScene() {
        let scene: MainMenuScene = MainMenuScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.remakeScene(with: previousSceneChildren)
        super.view?.presentScene(scene)
    }
}
