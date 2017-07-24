//
//  GameScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ActionHandlerDelegate, BoardDelegate {
    
    // MARK: - Properties
    
    public var currentLevel : Level!
    private var hud : Hud!
    private var template : TemplateBoard!
    private var playerBoard : BoardNode!
    private var hasGameBegun = false
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = UIColor.white
        self.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        setHud(from: view)
        setTemplate(from: view)
        setPlayerBoard(from: view)
        
        if !hasGameBegun {
            template.show()
        } else {
            playerBoard.addGestureRecognizer()
        }
        
        hasGameBegun = true
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
    }
    
    override func update(_ currentTime: TimeInterval) {
        hud.movesLabel.text = String(currentLevel.playerMoves)
        
        if !playerBoard.isMoving && currentLevel.hasLevelWon() {
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
    
    func setPlayerBoard(from view: SKView) {
		playerBoard = BoardNode(with: view.bounds.size, board: currentLevel.playerBoard, needsExtraCells: true)
        playerBoard.boardDelegate = self
        addChild(playerBoard)
    }
    
    func answerAction() {
        if template.isUserInteractionEnabled {
            if template.isHidden {
                playerBoard.disableGestureRecognizer()
                template.show()
            } else {
                template.hide()
                playerBoard.addGestureRecognizer()
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
    
    func configurationsAction() {
        
    }
	
	func updateMatrixAction(orientation: Orientation, columnOrRow: Int, moves: Int) {
		if orientation == .vertical && moves > 0 && columnOrRow >= 0 {
			currentLevel.moveUpPlayerBoard(column: columnOrRow, moves: abs(moves))
		} else if orientation == .vertical && moves < 0 && columnOrRow >= 0 {
			currentLevel.moveDownPlayerBoard(column: columnOrRow, moves:abs(moves))
		} else if orientation == .horizontal && moves > 0 && columnOrRow >= 0 {
			currentLevel.moveRightPlayerBoard(row: columnOrRow, moves: abs(moves))
		} else if orientation == .horizontal && moves < 0 && columnOrRow >= 0 {
			currentLevel.moveLeftPlayerBoard(row: columnOrRow, moves: abs(moves))
		}
	}
    
    func goToResultsScene() {
        let scene: ResultsScene = ResultsScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.currentLevel = currentLevel
        super.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
    }
}
