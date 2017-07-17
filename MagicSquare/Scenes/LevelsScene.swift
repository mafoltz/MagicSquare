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
    
    let json: [[String: Any]] = JsonReader.openJson(named: "World")!
    var levels = [Level]()
    
    var levelsScreenWidth: CGFloat!
    let verticalSpacing: CGFloat = 67
    let horizontalSpacing: CGFloat = 50
    let cornerRadius: CGFloat = 30
    
    var previousSceneChildren: SKSpriteNode!
    var backgroundScreen: SKSpriteNode!
    var levelsScreen: SKShapeNode!
    var levelsScreenShadow: SKSpriteNode!
    var levelsNodes = [SKSpriteNode!]()
    
    var touchLocation: CGPoint?
    var isMoving = false
    
    func prepareScene(from previousScene: SKScene) {
        previousSceneChildren = SKSpriteNode(color: UIColor.white, size: (previousScene.view?.bounds.size)!)
        previousSceneChildren.name = "Previous Scene Children"
        
        for child in previousScene.children {
            child.removeFromParent()
            previousSceneChildren.addChild(child)
        }
        
        previousScene.removeAllChildren()
        previousScene.removeAllActions()
        addChild(previousSceneChildren)
    }
    
    override func didMove(to view: SKView) {
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.35)
        backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.name = "Background Screen"
        backgroundScreen.zPosition = 1
        addChild(backgroundScreen)
        
        levelsScreenWidth = view.bounds.size.width
        let roundedRect = CGRect(x: horizontalSpacing - (view.bounds.size.width / 2),
                                 y: verticalSpacing - (view.bounds.size.height / 2),
                                 width: levelsScreenWidth!,
                                 height: view.bounds.size.height - 2 * verticalSpacing)
        levelsScreen = SKShapeNode()
        levelsScreen.name = "Levels Screen"
        levelsScreen.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        levelsScreen.fillColor = UIColor.white
        levelsScreen.zPosition = 2
        addChild(levelsScreen)
        
        for i in 0..<json.count {
            levels.append(JsonReader.loadLevel(from: json, numberOfLevel: i+1)!)
            
            let spriteNode = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 50))
            levelsNodes.append(spriteNode)
            levelsScreen.addChild(levelsNodes[i])
            levelsNodes[i].run(SKAction.move(by: CGVector(dx: i*60, dy: 0), duration: 0.0))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isUserInteractionEnabled = false
        
        let touch: UITouch = touches.first as UITouch!
        touchLocation = touch.location(in: self)
        
        if !levelsScreen.contains(touchLocation!) {
            backToMainMenuScene()
        }
        
        for i in 0..<levelsNodes.count {
            if levelsNodes[i].contains(touchLocation!) {
                goToGameScene(with: levels[i])
            }
        }
    }
    
    func backToMainMenuScene() {
        let scene: MainMenuScene = MainMenuScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        super.view?.presentScene(scene)
    }
    
    func goToGameScene(with level: Level) {
        let scene: GameScene = GameScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.currentLevel = level
        super.view?.presentScene(scene)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMoving && levelsScreen.contains(touchLocation!) {
            let touch: UITouch = touches.first as UITouch!
            let newTouchLocation = touch.location(in: self)
        
            levelsScreen.run(SKAction.move(by: CGVector(dx: newTouchLocation.x - (touchLocation?.x)!, dy: 0), duration: 0.0))
            touchLocation = newTouchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = true
        let limit = (view?.bounds.size.width)! - 2 * horizontalSpacing - levelsScreenWidth!
        
        if levelsScreen.position.x < limit {
            levelsScreen.run(SKAction.moveTo(x: limit, duration: 0.2))
        }
        else if levelsScreen.position.x > 0 {
            levelsScreen.run(SKAction.moveTo(x: 0, duration: 0.2))
        }
        
        isUserInteractionEnabled = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !(scene?.hasActions())! {
            isMoving = false
        }
    }
}
