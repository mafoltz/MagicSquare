//
//  ResultsScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class ResultsScene: SKScene {
    
    // MARK: - Properties
    
    public var currentLevel : Level?
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let json: [[String: Any]] = JsonReader.openJson(named: "World")!
        if (currentLevel?.number)! < json.count - 1 {
            let scene: GameScene = GameScene()
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.size = (super.view?.bounds.size)!
            scene.scaleMode = .aspectFill
            scene.currentLevel = JsonReader.loadLevel(from: json, numberOfLevel: (currentLevel?.number)! + 1)
            super.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
        }
        else {
            let scene: LevelsScene = LevelsScene()
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.size = (super.view?.bounds.size)!
            scene.scaleMode = .aspectFill
            scene.prepareScene(from: self.scene!)
            super.view?.presentScene(scene)
        }
    }
}
