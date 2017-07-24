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
    
    // MARK: - Properties
    
    private let json: [[String: Any]] = JsonReader.openJson(named: "World")!
    private var levels = [Level]()
    
    private var previousScene: SKScene!
    private var previousSceneChildren: SKSpriteNode!
    private var backgroundScreen: SKSpriteNode!
    private var levelsScreen: SKShapeNode!
    private var levelsScreenShadow: SKSpriteNode!
    private var levelsNodes = [SKSpriteNode!]()
    private var levelsLabelNodes = [SKLabelNode!]()
    
    private var indexOfTouchedLevel: Int! = -1
    private var initialTouchLocation: CGPoint?
    private var touchLocation: CGPoint?
    private var isMoving = false
    
    private var numLevels: Int!
    private var numLevelsColumns: Int!
    private let levelsByColumn: Int! = 4
    private var levelsSize: CGFloat!
    private var levelsScreenWidth: CGFloat!
    private var levelsScreenHeight: CGFloat!
    private var verticalSpacingFromTopAndBottom: CGFloat!
    private var verticalSpacingBetweenLevels: CGFloat!
    private var horizontalSpacingBetweenLevels: CGFloat!
    private let screenVerticalSpacing: CGFloat = 67
    private let screenHorizontalSpacing: CGFloat = 50
    private let cornerRadius: CGFloat = 30
    private let moveTolerance: CGFloat = 10
    
    // MARK: - Methods
    
    func prepareScene(from previousScene: SKScene) {
        backgroundColor = UIColor.white
        
        self.previousScene = previousScene
        previousSceneChildren = SKSpriteNode(color: UIColor.white, size: (previousScene.view?.bounds.size)!)
        previousSceneChildren.name = "Previous Scene Children"
        previousSceneChildren.zPosition = 0.0
        
        for child in previousScene.children {
            child.removeFromParent()
            previousSceneChildren.addChild(child)
        }
        
        previousScene.removeAllChildren()
        previousScene.removeAllActions()
        addChild(previousSceneChildren)
        
        if (previousScene as? GameScene) != nil {
            previousSceneChildren.run(SKAction.moveBy(x: 0.0, y: -(previousScene.view?.bounds.size.height)! / 2, duration: 0.0))
        }
    }
    
    override func didMove(to view: SKView) {
        calculateSizes()
        
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.35)
        backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.name = "Background Screen"
        backgroundScreen.zPosition = 5.1
        addChild(backgroundScreen)
        
        let roundedRect = CGRect(x: screenHorizontalSpacing - (view.bounds.size.width / 2),
                                 y: screenVerticalSpacing - (view.bounds.size.height / 2),
                                 width: levelsScreenWidth!,
                                 height: levelsScreenHeight!)
        levelsScreen = SKShapeNode()
        levelsScreen.name = "Levels Screen"
        levelsScreen.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        levelsScreen.fillColor = UIColor.white
        levelsScreen.zPosition = 5.2
        addChild(levelsScreen)
        
        for i in 0..<json.count {
            levels.append(JsonReader.loadLevel(from: json, numberOfLevel: i+1)!)
            
            let spriteNode = CoinSpriteNode()
            spriteNode.setCoinForRecord(from: levels[i])
            spriteNode.size = CGSize(width: levelsSize, height: levelsSize)
            resetAnchor(of: spriteNode)
            spriteNode.run(SKAction.moveBy(x: horizontalSpacingBetweenLevels + CGFloat(i / levelsByColumn) * (levelsSize + horizontalSpacingBetweenLevels),
                                           y: -verticalSpacingFromTopAndBottom - CGFloat(i % levelsByColumn) * (levelsSize + verticalSpacingBetweenLevels),
                                           duration: 0.0))
            spriteNode.zPosition = 5.3
            levelsScreen.addChild(spriteNode)
            levelsNodes.append(spriteNode)
            
            let labelNode = SKLabelNode(text: levels[i].level)
            labelNode.fontColor = UIColor(colorLiteralRed: 92/256, green: 91/256, blue: 91/256, alpha: 1)
            labelNode.fontName = UIFont(name: ".SFUIText-Medium", size: 18.0)?.fontName
            labelNode.fontSize = 18.0
            labelNode.run(SKAction.moveBy(x: 0, y: -4 * spriteNode.size.height / 5, duration: 0.0))
            labelNode.zPosition = 5.3
            spriteNode.addChild(labelNode)
            levelsLabelNodes.append(labelNode)
        }
        
        let hideLevels = SKAction.moveBy(x: view.bounds.size.width - screenHorizontalSpacing, y: 0.0, duration: 0.0)
        let moveLevels = SKAction.moveBy(x: screenHorizontalSpacing - view.bounds.size.width - 20.0, y: 0.0, duration: 0.3)
        let moveLevelsQuickly = SKAction.moveBy(x: 20.0, y: 0.0, duration: 0.01)
        moveLevelsQuickly.timingMode = .easeOut
        let actionsSequence = SKAction.sequence([hideLevels, moveLevels, moveLevelsQuickly])
        levelsScreen.run(actionsSequence)
        
        isUserInteractionEnabled = false
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.setUserInteractionEnabled), userInfo: nil, repeats: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isUserInteractionEnabled = false
        
        let touch: UITouch = touches.first as UITouch!
        initialTouchLocation = touch.location(in: self)
        touchLocation = touch.location(in: self)
        
        if !levelsScreen.contains(touchLocation!) {
            goBackToPreviousScene()
        }
        
        for i in 0..<levelsNodes.count {
            if levelsNodes[i].contains(CGPoint(x: (touchLocation?.x)! - levelsScreen.position.x,
                                               y: (touchLocation?.y)!)) {
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
            let move = SKAction.moveTo(x: limit, duration: 0.2)
            move.timingMode = .easeOut
            levelsScreen.run(move)
        }
        else if levelsScreen.position.x > 0 {
            let move = SKAction.moveTo(x: 0, duration: 0.2)
            move.timingMode = .easeOut
            levelsScreen.run(move)
        }
        
        if indexOfTouchedLevel >= 0 && abs((touchLocation?.x)! - (initialTouchLocation?.x)!) <= moveTolerance &&
            levelsNodes[indexOfTouchedLevel].contains(CGPoint(x: (touchLocation?.x)! - levelsScreen.position.x,
                                                              y: (touchLocation?.y)!)) {
            goToGameScene(with: levels[indexOfTouchedLevel])
        }
        
        isUserInteractionEnabled = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !levelsScreen.hasActions() {
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
    
    func setUserInteractionEnabled() {
        isUserInteractionEnabled = true
    }
    
    func goBackToPreviousScene() {
        if let scene = previousScene as? MainMenuScene {
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.size = (super.view?.bounds.size)!
            scene.scaleMode = .aspectFill
            super.view?.presentScene(scene)
        }
        else if let scene = previousScene as? GameScene {
            super.view?.presentScene(scene)
        }
    }
    
    func goToGameScene(with level: Level) {
        let scene: GameScene = GameScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.currentLevel = level
        super.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
    }
}


