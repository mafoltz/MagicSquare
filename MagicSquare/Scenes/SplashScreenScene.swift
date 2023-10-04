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
        
        background = SKSpriteNode(imageNamed: "splashBackground")
        background.size = CGSize(width: background.size.width * size.height / background.size.height,
                                 height: size.height)
        background.zPosition = 0.1
        addChild(background)
        
        Timer.scheduledTimer(timeInterval: 2.00, target: self, selector: #selector(goToGameScene), userInfo: nil, repeats: false)
    }

    @objc
    func goToGameScene() {
        let scene = GameScene()
        var world = UserDefaults.standard.string(forKey: "world")
        let level = UserDefaults.standard.integer(forKey: "level")

        let initialWorld = "4x3 Esle's Starter Pack"
        UserDefaults.standard.set(initialWorld, forKey: "world")
        
        let json: [[String: Any]] = JsonReader.openJson(named: world!)!
        scene.currentLevel = JsonReader.loadLevel(from: json, worldName: world!, numberOfLevel: level)!

        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (self.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
    }
}
