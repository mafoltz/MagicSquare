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
    private var background: SKSpriteNode!
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        esle = SKSpriteNode(imageNamed: "1")
        esle.size = CGSize(width: 94, height: 145)
        esle.zPosition = 0.2
        let movement = SKAction.animate(with: [SKTexture(imageNamed: "1"), SKTexture(imageNamed: "2"),
                                               SKTexture(imageNamed: "3"), SKTexture(imageNamed: "4"),
                                               SKTexture(imageNamed: "5"), SKTexture(imageNamed: "6"),
                                               SKTexture(imageNamed: "7"), SKTexture(imageNamed: "8")],
                                        timePerFrame: 0.1)
        let animation = SKAction.repeatForever(movement)
        esle.run(animation)
        addChild(esle)
        
        background = SKSpriteNode(imageNamed: "fundoSplash")
        background.size = CGSize(width: background.size.width * size.height / background.size.height,
                                 height: size.height)
        background.zPosition = 0.1
        addChild(background)
        
        Timer.scheduledTimer(timeInterval: 2.00, target: self, selector: #selector(goToGameScene), userInfo: nil, repeats: false)
    }
    
    func goToGameScene() {
        let scene = GameScene()
        let json: [[String: Any]] = JsonReader.openJson(named: "World")!
        scene.currentLevel = JsonReader.loadLevel(from: json, numberOfLevel:UserDefaults.standard.integer(forKey: "level"))!
        //JsonReader.loadLevel(from: json, numberOfLevel: 1)!
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (self.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
    }
}
