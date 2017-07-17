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
    
    var previousSceneChildren: SKSpriteNode!
    var backgroundScreen: SKSpriteNode!
    var levelsScreen: SKShapeNode!
    var levelsScreenShadow: SKSpriteNode!
    var levelsNodes = [SKSpriteNode!]()
    var levelsLabelNodes = [SKLabelNode!]()
    
    var indexOfTouchedLevel: Int! = -1
    var touchLocation: CGPoint?
    var isMoving = false
    
    var numLevels: Int!
    var numLevelsColumns: Int!
    let levelsByColumn: Int! = 4
    var levelsSize: CGFloat!
    var levelsScreenWidth: CGFloat!
    var levelsScreenHeight: CGFloat!
    var verticalSpacingFromTopAndBottom: CGFloat!
    var verticalSpacingBetweenLevels: CGFloat!
    var horizontalSpacingBetweenLevels: CGFloat!
    let screenVerticalSpacing: CGFloat = 67
    let screenHorizontalSpacing: CGFloat = 50
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
        calculateSizes()
        
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.35)
        backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.name = "Background Screen"
        backgroundScreen.zPosition = 1
        addChild(backgroundScreen)
        
        let roundedRect = CGRect(x: screenHorizontalSpacing - (view.bounds.size.width / 2),
                                 y: screenVerticalSpacing - (view.bounds.size.height / 2),
                                 width: levelsScreenWidth!,
                                 height: levelsScreenHeight!)
        levelsScreen = SKShapeNode()
        levelsScreen.name = "Levels Screen"
        levelsScreen.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        levelsScreen.fillColor = UIColor.white
        levelsScreen.zPosition = 2
        addChild(levelsScreen)
        
        for i in 0..<json.count {
            levels.append(JsonReader.loadLevel(from: json, numberOfLevel: i+1)!)
            
            let spriteNode = SKSpriteNode(imageNamed: "goldenLevel")
            spriteNode.size = CGSize(width: levelsSize, height: levelsSize)
            resetAnchor(of: spriteNode)
            spriteNode.run(SKAction.moveBy(x: horizontalSpacingBetweenLevels + CGFloat(i / levelsByColumn) * (levelsSize + horizontalSpacingBetweenLevels),
                                           y: -verticalSpacingFromTopAndBottom - CGFloat(i % levelsByColumn) * (levelsSize + verticalSpacingBetweenLevels),
                                           duration: 0.0))
            spriteNode.zPosition = 3
            levelsScreen.addChild(spriteNode)
            levelsNodes.append(spriteNode)
            
            let labelNode = SKLabelNode(text: levels[i].level)
            labelNode.fontColor = UIColor(colorLiteralRed: 92/256, green: 91/256, blue: 91/256, alpha: 1)
            labelNode.fontName = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize).fontName
            labelNode.fontSize = 20.0
            labelNode.run(SKAction.moveBy(x: 0, y: -4 * spriteNode.size.height / 5, duration: 0.0))
            labelNode.zPosition = 3
            spriteNode.addChild(labelNode)
            levelsLabelNodes.append(labelNode)
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
                indexOfTouchedLevel = i
                break
            } else {
                indexOfTouchedLevel = -1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMoving && levelsScreen.contains(touchLocation!) {
            let touch: UITouch = touches.first as UITouch!
            let newTouchLocation = touch.location(in: self)
        
            levelsScreen.run(SKAction.moveBy(x: newTouchLocation.x - (touchLocation?.x)!, y: 0, duration: 0.0))
            touchLocation = newTouchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = true
        let limit = (view?.bounds.size.width)! - 2 * screenHorizontalSpacing - levelsScreenWidth!
        
        if levelsScreen.position.x < limit {
            levelsScreen.run(SKAction.moveTo(x: limit, duration: 0.2))
        }
        else if levelsScreen.position.x > 0 {
            levelsScreen.run(SKAction.moveTo(x: 0, duration: 0.2))
        }
        
        if indexOfTouchedLevel >= 0 && levelsNodes[indexOfTouchedLevel].contains(touchLocation!) {
            goToGameScene(with: levels[indexOfTouchedLevel])
        }
        
        isUserInteractionEnabled = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !(scene?.hasActions())! {
            isMoving = false
        }
    }
    
    func calculateSizes() {
        numLevels = json.count
        numLevelsColumns = ((numLevels - 1) / levelsByColumn) + 1
        levelsScreenHeight = (super.view?.bounds.size.height)! - 2 * screenVerticalSpacing
        levelsSize = 0.156 * levelsScreenHeight
        verticalSpacingFromTopAndBottom = 0.051 * levelsScreenHeight
        verticalSpacingBetweenLevels = 0.08 * levelsScreenHeight
        horizontalSpacingBetweenLevels = 0.075 * levelsScreenHeight
        levelsScreenWidth = CGFloat(numLevelsColumns) * (levelsSize + horizontalSpacingBetweenLevels) + horizontalSpacingBetweenLevels
    }
    
    func resetAnchor(of spriteNode: SKSpriteNode) {
        spriteNode.run(SKAction.moveBy(x: screenHorizontalSpacing + ((spriteNode.size.width - (super.view?.bounds.size.width)!) / 2),
                                       y: (((super.view?.bounds.size.height)! - spriteNode.size.height) / 2) - screenVerticalSpacing,
                                       duration: 0.0))
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
}
