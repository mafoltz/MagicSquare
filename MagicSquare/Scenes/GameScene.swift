//
//  GameScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Orientation {
    case vertical
    case horizontal
    case neutral
}


class GameScene: SKScene, ActionHandlerDelegate {
    // MARK: - Properties
    
    //    weak var myDelegate: GameSceneDelegate
    
    public var currentLevel : Level!
    private var playerBoard : [[SKShapeNode]]!
    
    private var hud : Hud!
    public var template : TemplateBoard!
    
    private var cellsSize : CGSize!
    private var cellsSpacing : CGFloat!
    private var bottomSpacing : CGFloat!
    private var numPositionMoved : Int!
    private var direction = Orientation.neutral
    private var row : Int! 
    private var column : Int!
    private var boardDisplay : SKCropNode!
    private var boardContentNode : SKNode!
    
    //MARK: - Touches in screen
    
    private var firstTouch : CGPoint!
    private var penultimateTouch : CGPoint!
    private var nextTouch : CGPoint!
    private var lastTouch : CGPoint!
    private var storeFirstNodePosition : CGPoint!
    private var moves : Int!
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        
        self.scene?.backgroundColor = UIColor.white
        self.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
//        calculateSizes()
        setHud(from: view)
        setTemplate(from: view)
        let boardNode = BoardNode(with: self.size, and: currentLevel)
        addChild(boardNode)
        boardNode.addGestureRecognizer()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
    }
    
    override func update(_ currentTime: TimeInterval) {
        hud.movesLabel.text = String(currentLevel.playerMoves)
    }
    
    func setHud(from view: SKView) {
        hud = Hud(color: UIColor(red: 174/256, green: 210/256, blue: 214/256, alpha: 1.0),
                  size: CGSize(width: view.bounds.size.width, height: 0.225 * view.bounds.size.height))
        hud.run(SKAction.moveTo(y: view.bounds.size.height - hud.size.height / 2, duration: 0.0))
        hud.setHud(from: currentLevel)
        hud.actionDelegate = self
        addChild(hud)
    }
    
    func setTemplate(from view: SKView) {
        template = TemplateBoard()
        template.setTemplate(from: currentLevel, view: view)
        addChild(template)
    }
    
    func answerAction() {
        if template.isHidden {
            template.show()
        } else {
            template.hide()
        }
    }
    
    func hintAction() {
        
    }
    
    func levelsAction() {
        for gesture in (view?.gestureRecognizers!)! {
            gesture.isEnabled = false
        }
        
        let scene: LevelsScene = LevelsScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.prepareScene(from: self.scene!)
        view?.presentScene(scene)
    }
    
}
