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
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
        backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.zPosition = 1
        addChild(backgroundScreen)
        
        
    }
}
