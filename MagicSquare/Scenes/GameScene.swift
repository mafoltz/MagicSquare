//
//  GameScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ActionHandlerDelegate {
    // MARK: - Properties
    
    public var currentLevel : Level!
    private var hud : Hud!
    private var template : TemplateBoard!
    private var boardNode : BoardNode!
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = UIColor.white
        self.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        setHud(from: view)
        setTemplate(from: view)
        
		boardNode = BoardNode(with: self.size, level: currentLevel, isPlayerBoard: true)
        addChild(boardNode)
        boardNode.addGestureRecognizer()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
    }
    
    override func update(_ currentTime: TimeInterval) {
        hud.movesLabel.text = String(currentLevel.playerMoves)
        
        if currentLevel.hasLevelWon() {
            goToResultsScene()
        }
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
    
    func goToResultsScene() {
        let scene: ResultsScene = ResultsScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.currentLevel = currentLevel
        super.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
    }
    
    func answerAction() {
        if template.isUserInteractionEnabled {
            if template.isHidden {
                boardNode.disableGestureRecognizer()
                template.show()
            } else {
                template.hide()
                boardNode.addGestureRecognizer()
            }
        }
    }
    
    func levelsAction() {
        for gesture in (view?.gestureRecognizers!)! {
            gesture.isEnabled = false
        }
        
        let scene: LevelsScene = LevelsScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.prepareScene(from: self.scene!)
        super.view?.presentScene(scene)
    }
    
    func hintAction() {
        
    }
}
