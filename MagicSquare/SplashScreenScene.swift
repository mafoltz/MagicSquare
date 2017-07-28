//
//  SplashScreenScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 26/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class SplashScreenScene: SKScene {
    
    // MARK: - Properties
    
    private var esle: SKSpriteNode!
    private var background: SKLabelNode!
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        esle = SKSpriteNode()
        esle.zPosition = 0.2
        let animation = SKAction.animate(with: [SKTexture(imageNamed: "1"), SKTexture(imageNamed: "2"),
                                                SKTexture(imageNamed: "3"), SKTexture(imageNamed: "4"),
                                                SKTexture(imageNamed: "5"), SKTexture(imageNamed: "6"),
                                                SKTexture(imageNamed: "7"), SKTexture(imageNamed: "8")],
                                         timePerFrame: 0.05)
        esle.run(animation)
        addChild(esle)
        
        /*background = SKSpriteNode(imageNamed: "fundoSplash")
        background.zPosition = 0.1
        addChild(background)*/
    }
}
