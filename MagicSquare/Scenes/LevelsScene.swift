//
//  LevelsScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

enum Direction {
    case up
    case down
}

class LevelsScene: SKScene {
    
    // MARK: - Properties
    
    private let json: [[String: Any]] = JsonReader.openJson(named: UserDefaults.standard.string(forKey: "world")!)!
    private var levelsPacks = [[[String: Any]]]()
    private var levels = [Level]()
    
    private var previousScene: SKScene!
    private var previousSceneChildren: SKSpriteNode!
    private var backgroundScreen: SKSpriteNode!
    private var levelsScreen: SKShapeNode!
    private var titleBackground: SKSpriteNode!
    private var backButton: SKSpriteNode!
    private var levelsNodes = [SKSpriteNode!]()
    private var levelsLabelNodes = [SKLabelNode!]()
    private var screenDisplay = SKCropNode()
    
    private var indexOfTouchedLevel: Int! = -1
    private var initialTouchLocation: CGPoint?
    private var touchLocation: CGPoint?
    private var isMoving = false
    
    private var numPacks: Int! = 0
    private var numLevelsRows: Int! = 0
    private let levelsByRow: Int! = 4
    private var levelsSize: CGFloat!
    private var levelsScreenWidth: CGFloat!
    private var levelsScreenHeight: CGFloat!
    private var levelsScreenHeightLimit: CGFloat!
    private var firstLevelMargin: CGFloat!
    private var backButtonHeight: CGFloat!
    private var titleBackgroundHeight: CGFloat!
    private var verticalSpacingBetweenLevels: CGFloat!
    private var horizontalSpacingBetweenLevels: CGFloat!
    private var screenVerticalSpacing: CGFloat!
    private var screenHorizontalSpacing: CGFloat!
    private var packTitleInitialHeightDisplacement: CGFloat!
    private var packFirstLevelInitialHeightDisplacement: CGFloat!
    private let cornerRadius: CGFloat = 30
    private let moveTolerance: CGFloat = 10
    private let moveToleranceToCloseScene: CGFloat = 150
    
    // MARK: - Methods
    
    func prepareScene(from previousScene: SKScene) {
        backgroundColor = .white
        
        self.previousScene = previousScene
        previousSceneChildren = SKSpriteNode(color: .white, size: (previousScene.view?.bounds.size)!)
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
        // TEST
        //levelsPacks.append(json)
        levelsPacks.append(json)
        
        calculateSizes(from: view)
        
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.35)
        backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.zPosition = 5.1
        addChild(backgroundScreen)
        
        let maskRect = CGRect(x: screenHorizontalSpacing - (view.bounds.size.width / 2),
                              y: (-view.bounds.size.height - titleBackgroundHeight) / 2 - screenVerticalSpacing,
                              width: levelsScreenWidth!,
                              height: view.bounds.size.height)
        let mask = SKShapeNode()
        mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: 0).cgPath
        mask.fillColor = .black
        screenDisplay.maskNode = mask
        screenDisplay.zPosition = 5.2
        addChild(screenDisplay)
        
        let roundedRect = CGRect(x: screenHorizontalSpacing - (view.bounds.size.width / 2),
                                 y: (view.bounds.size.height / 2) - screenVerticalSpacing - levelsScreenHeight!,
                                 width: levelsScreenWidth!,
                                 height: levelsScreenHeight!)
        levelsScreen = SKShapeNode()
        levelsScreen.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: floor(cornerRadius * view.bounds.size.width / 375)).cgPath
        levelsScreen.fillColor = .white
        levelsScreen.zPosition = 0.1
        screenDisplay.addChild(levelsScreen)
        
        titleBackground = SKSpriteNode(imageNamed: "LevelsScreenTitleBackground")
        titleBackground.size = CGSize(width: levelsScreenWidth + 2, height: titleBackgroundHeight)
        titleBackground.run(SKAction.moveTo(y: (view.bounds.size.height - titleBackgroundHeight) / 2 - screenVerticalSpacing + 1, duration: 0.0))
        titleBackground.zPosition = 6.0
        addChild(titleBackground)
        
        backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.size = CGSize(width: backButtonHeight, height: backButtonHeight)
        backButton.run(SKAction.move(to: CGPoint(x: -0.4 * levelsScreenWidth, y: 0.0), duration: 0.0))
        backButton.zPosition = 0.1
        titleBackground.addChild(backButton)
        
        let levelsTitle = SKLabelNode(text: "LEVELS")
        levelsTitle.fontColor = .white
        levelsTitle.fontName = ".SFUIText-Medium"
        levelsTitle.fontSize = getFontSize(fontSize: 18.0, screenHeight: view.bounds.size.height)
        levelsTitle.verticalAlignmentMode = .center
        levelsTitle.horizontalAlignmentMode = .center
        levelsTitle.zPosition = 0.1
        titleBackground.addChild(levelsTitle)
        
        for pack in levelsPacks {
            let world = UserDefaults.standard.string(forKey: "world")
            
            let packTitle = SKLabelNode(text: "4x3 Esle's Starter Pack")
            packTitle.fontColor = UIColor(colorLiteralRed: 47/256, green: 66/256, blue: 67/256, alpha: 1.0)
            packTitle.fontName = ".SFUIText-Medium"
            packTitle.fontSize = getFontSize(fontSize: 18.0, screenHeight: view.bounds.size.height)
            packTitle.verticalAlignmentMode = .center
            packTitle.horizontalAlignmentMode = .center
            packTitle.run(SKAction.moveTo(y: packTitleInitialHeightDisplacement, duration: 0.0))
            packTitle.zPosition = 0.1
            levelsScreen.addChild(packTitle)
            
            for i in 0..<json.count {
                levels.append(JsonReader.loadLevel(from: json, worldName: world!, numberOfLevel: i+1)!)
                
                let spriteNode = CoinSpriteNode()
                spriteNode.setCoinForRecord(from: levels[i])
                spriteNode.size = CGSize(width: levelsSize, height: levelsSize)
                resetAnchor(of: spriteNode)
                spriteNode.run(SKAction.moveBy(x: firstLevelMargin + CGFloat(i % levelsByRow) * (levelsSize + horizontalSpacingBetweenLevels),
                                               y: packFirstLevelInitialHeightDisplacement - CGFloat(i / levelsByRow) * (levelsSize + verticalSpacingBetweenLevels),
                                               duration: 0.0))
                spriteNode.zPosition = 0.1
                levelsScreen.addChild(spriteNode)
                levelsNodes.append(spriteNode)
                
                let labelNode = SKLabelNode(text: levels[i].level)
                labelNode.fontColor = levels[i].getMedalColorForRecord()
                labelNode.fontName = ".SFUIText-Heavy"
                labelNode.fontSize = getFontSize(fontSize: 28.0, screenHeight: view.bounds.size.height)
                labelNode.verticalAlignmentMode = .center
                labelNode.horizontalAlignmentMode = .center
                labelNode.zPosition = 0.1
                spriteNode.addChild(labelNode)
                levelsLabelNodes.append(labelNode)
            }
            
            updatePacksHeightDisplacements(with: screenHeight(forNumOfLevels: pack.count))
        }
        
        let hideLevels = SKAction.moveBy(x: 0.0, y: screenVerticalSpacing - view.bounds.size.height, duration: 0.0)
        let moveLevels = SKAction.moveBy(x: 0.0, y: view.bounds.size.height - screenVerticalSpacing, duration: 0.3)
        moveLevels.timingMode = .easeOut
        let actionsSequence = SKAction.sequence([hideLevels, moveLevels])
        
        levelsScreen.run(actionsSequence, completion: {
            if let hud: Hud = self.previousSceneChildren.childNode(withName: "hud") as? Hud {
                hud.resetEslePosition()
            }
            self.isUserInteractionEnabled = true
        })
        titleBackground.run(actionsSequence)
        
        isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMoving {
            isUserInteractionEnabled = false
            
            let touch: UITouch = touches.first as UITouch!
            initialTouchLocation = touch.location(in: self)
            touchLocation = touch.location(in: self)
            
            for i in 0..<levelsNodes.count {
                if levelsNodes[i].contains(CGPoint(x: (touchLocation?.x)!, y: (touchLocation?.y)! - levelsScreen.position.y)) {
                    indexOfTouchedLevel = i
                    break
                } else {
                    indexOfTouchedLevel = -1
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMoving {
            let touch: UITouch = touches.first as UITouch!
            let newTouchLocation = touch.location(in: self)
            let move = SKAction.moveBy(x: 0.0, y: newTouchLocation.y - (touchLocation?.y)!, duration: 0.0)
            
            levelsScreen.run(move)
            if levelsScreen.position.y <= 0 && newTouchLocation.y - (touchLocation?.y)! < 0 {
                titleBackground.run(move)
            }
            
            touchLocation = newTouchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = true
        
        if backButton.contains(CGPoint(x: (touchLocation?.x)!, y: (touchLocation?.y)! - titleBackground.position.y)) &&
            abs((touchLocation?.y)! - (initialTouchLocation?.y)!) <= moveTolerance {
            closeLevelsScene(to: .down)
        }
        
        if levelsScreen.position.y > levelsScreenHeightLimit {
            if abs(levelsScreen.position.y - levelsScreenHeightLimit) <= moveToleranceToCloseScene {
                let move = SKAction.moveTo(y: levelsScreenHeightLimit, duration: 0.2)
                move.timingMode = .easeOut
                levelsScreen.run(move)
            } else {
                closeLevelsScene(to: .up)
            }
        }
        else if levelsScreen.position.y < 0 {
            if abs(levelsScreen.position.y) <= moveToleranceToCloseScene {
                let titleMove = SKAction.moveTo(y: ((view?.bounds.size.height)! - titleBackgroundHeight) / 2 - screenVerticalSpacing + 1, duration: 0.2)
                titleMove.timingMode = .easeOut
                titleBackground.run(titleMove)
                
                let move = SKAction.moveTo(y: 0.0, duration: 0.2)
                move.timingMode = .easeOut
                levelsScreen.run(move)
            } else {
                closeLevelsScene(to: .down)
            }
        }
        
        if indexOfTouchedLevel >= 0 && abs((touchLocation?.y)! - (initialTouchLocation?.y)!) <= moveTolerance &&
            levelsNodes[indexOfTouchedLevel].contains(CGPoint(x: (touchLocation?.x)!,
                                                              y: (touchLocation?.y)! - levelsScreen.position.y)) {
            goToGameScene(with: levels[indexOfTouchedLevel])
        }
        
        isUserInteractionEnabled = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !levelsScreen.hasActions() {
            isMoving = false
        }
    }
    
    func calculateSizes(from view: SKView) {
        screenVerticalSpacing = 20 * view.bounds.size.width / 375
        screenHorizontalSpacing = screenVerticalSpacing
        
        for json in levelsPacks {
            numPacks = numPacks + 1
            numLevelsRows = numLevelsRows + ((json.count - 1) / levelsByRow) + 1
        }
        
        levelsScreenWidth = view.bounds.size.width - 2 * screenHorizontalSpacing
        levelsSize = 0.17 * levelsScreenWidth
        
        firstLevelMargin = 0.07 * levelsScreenWidth
        backButtonHeight = floor(37 * view.bounds.size.width / 375)
        titleBackgroundHeight = 85 * levelsScreenWidth / 335
        
        verticalSpacingBetweenLevels = 0.06 * levelsScreenWidth
        horizontalSpacingBetweenLevels = 0.06 * levelsScreenWidth
        levelsScreenHeight = titleBackgroundHeight + 3 * CGFloat(numPacks) * verticalSpacingBetweenLevels + CGFloat(numLevelsRows) * (levelsSize + verticalSpacingBetweenLevels)
        levelsScreenHeightLimit = 2 * screenVerticalSpacing + levelsScreenHeight - view.bounds.size.height
        
        packTitleInitialHeightDisplacement = view.bounds.size.height / 2 - screenVerticalSpacing - titleBackgroundHeight - 1.5 * verticalSpacingBetweenLevels
        packFirstLevelInitialHeightDisplacement = -3 * verticalSpacingBetweenLevels - titleBackgroundHeight
    }
    
    func resetAnchor(of spriteNode: SKSpriteNode) {
        spriteNode.run(SKAction.moveBy(x: screenHorizontalSpacing + ((spriteNode.size.width - (super.view?.bounds.size.width)!) / 2),
                                       y: (((super.view?.bounds.size.height)! - spriteNode.size.height) / 2) - screenVerticalSpacing,
                                       duration: 0.0))
    }
    
    func screenHeight(forNumOfLevels numOfLevels: Int) -> CGFloat {
        let numLevelsRows = ((numOfLevels - 1) / levelsByRow) + 1
        return CGFloat(numLevelsRows) * (levelsSize + verticalSpacingBetweenLevels) + 3 * verticalSpacingBetweenLevels
    }
    
    func updatePacksHeightDisplacements(with packHeight: CGFloat) {
        packTitleInitialHeightDisplacement.subtract(packHeight)
        packFirstLevelInitialHeightDisplacement.subtract(packHeight)
    }
    
    func closeLevelsScene(to direction: Direction) {
        var y: CGFloat!
        if direction == .up {
            y = levelsScreenHeight
        } else {
            y = -(view?.bounds.size.height)!
        }
        
        let hideLevels = SKAction.moveTo(y: y, duration: 0.3)
        hideLevels.timingMode = .easeIn
        levelsScreen.run(hideLevels, completion: {
            self.isUserInteractionEnabled = true
            self.goBackToPreviousScene()
        })
        
        isUserInteractionEnabled = false
    }
    
    func goBackToPreviousScene() {
        if let scene = previousScene as? GameScene {
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            super.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.1))
        }
        else if let scene = previousScene as? MainMenuScene {
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.size = (super.view?.bounds.size)!
            scene.scaleMode = .aspectFill
            super.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.1))
        }
    }
    
    func goToGameScene(with level: Level) {
        if !level.locked {
            let scene: GameScene = GameScene()
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            scene.size = (super.view?.bounds.size)!
            scene.scaleMode = .aspectFill
            scene.currentLevel = level
            super.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
        }
    }
}
