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
    var levelsScreenShadow: SKSpriteNode!
    
    var touchLocation: CGPoint?
    
    var levelsScreenWidth: CGFloat?
    let verticalSpacing: CGFloat = 67
    let horizontalSpacing: CGFloat = 50
    let cornerRadius: CGFloat = 30
    
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        touchLocation = touch.location(in: self)
        
        if !levelsScreen.contains(touchLocation!) {
            backToMainMenuScene()
        }
    }
    
    func backToMainMenuScene() {
        let scene: MainMenuScene = MainMenuScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        super.view?.presentScene(scene)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        let newTouchLocation = touch.location(in: self)
        
        if levelsScreen.contains(touchLocation!) {
            levelsScreen.run(SKAction.move(by: CGVector(dx: newTouchLocation.x - (touchLocation?.x)!, dy: 0), duration: 0.0))
            touchLocation = newTouchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let limit = (view?.bounds.size.width)! - 2 * horizontalSpacing - levelsScreenWidth!
        
        if levelsScreen.position.x < limit {
            levelsScreen.run(SKAction.moveTo(x: limit, duration: 0.2))
        }
        else if levelsScreen.position.x > 0 {
            levelsScreen.run(SKAction.moveTo(x: 0, duration: 0.2))
        }
    }
}
