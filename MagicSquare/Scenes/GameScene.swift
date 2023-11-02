//
//  GameScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import SwiftUI

protocol GameSceneDelegate: AnyObject {
    func refreshSceneElements()
}

class GameScene: SKScene, ActionHandlerDelegate, BoardDelegate, GameSceneDelegate {

    // MARK: - Properties
    
    public var currentLevel: Level!

    private var hud: Hud!
    private var template: TemplateBoard!
    private var playerBoard: BoardNode!
    private var gameOngoing = false

    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = UIColor.white
        self.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        setHud(from: view)
        setTemplate(from: view)

        if currentLevel.number == 1 && currentLevel.world == "4x3 Esle's Starter Pack" {
            setPlayerBoardTutorial(from: view)
        } else {
            setPlayerBoard(from: view)
        }
        
        if !gameOngoing {
            template.show()
        } else {
            playerBoard.addGestureRecognizer()
        }
		
        // Save current world and level
        SettingsManager.shared.saveCurrentLevel(currentLevel.number, world: currentLevel.world)

        gameOngoing = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        hud.movesLabel.text = String(currentLevel.playerMoves)
        
        if !playerBoard.isMoving && currentLevel.hasLevelWon() {
            playerBoard.disableGestureRecognizer()
            goToResultsScene()
        }
    }
    
    func setHud(from view: SKView) {
        let color = UIColor(red: 174/256, green: 210/256, blue: 214/256, alpha: 1.0)
        hud = Hud(color: color,
                  size: CGSize(width: view.bounds.size.width, height: 0.225 * view.bounds.size.height))
		hud.parentHeight = self.size.height
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
    
    func setPlayerBoardTutorial(from view: SKView) {
        playerBoard = Tutorial(with: view.bounds.size, board: currentLevel.playerBoard, needsExtraCells: true)
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
                if let board = playerBoard as? Tutorial {
                    if board.state == .touchInOctopus {
                        board.state = .octopusTouched
                    }
                }
                
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
        playerBoard.disableGestureRecognizer()

        let storyboard = UIStoryboard(name: "Settings", bundle: .main)
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController,
              let controller = navController.topViewController as? SettingsViewController else { return }

        controller.delegate = self

        self.view?.window?.rootViewController?.present(navController, animated: true, completion: nil)
    }
    
    func updateMatrixAction(orientation: Orientation, columnOrRow: Int, moves: Int) {
        let width = currentLevel.playerBoard.cellsMatrix[1].count
        let height = currentLevel.playerBoard.cellsMatrix.count
        
        if orientation == .vertical && (moves > 0 && moves != height) && columnOrRow >= 0 {
            currentLevel.moveUpPlayerBoard(column: columnOrRow, moves: abs(moves))
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(blinkWholeBoard),
                                 userInfo: ["column": columnOrRow], repeats: false)
        }
        else if orientation == .vertical && (moves < 0 && moves != -height) && columnOrRow >= 0 {
            currentLevel.moveDownPlayerBoard(column: columnOrRow, moves:abs(moves))
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(blinkWholeBoard), 
                                 userInfo: ["column": columnOrRow], repeats: false)
        }
        else if orientation == .horizontal && (moves > 0 && moves != width) && columnOrRow >= 0 {
            currentLevel.moveRightPlayerBoard(row: columnOrRow, moves: abs(moves))
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(blinkWholeBoard), 
                                 userInfo: ["row": columnOrRow], repeats: false)
        }
        else if orientation == .horizontal && (moves < 0 && moves != -width) && columnOrRow >= 0 {
            currentLevel.moveLeftPlayerBoard(row: columnOrRow, moves: abs(moves))
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(blinkWholeBoard), 
                                 userInfo: ["row": columnOrRow], repeats: false)
        }
    }

    @objc
    func blinkPlayerBoardInRow(timer: Timer) {
        let info = timer.userInfo as! NSDictionary
        let row = info.value(forKey: "row") as! Int
        playerBoard.blinkColor(inRow: row, level: currentLevel)
    }

    @objc
    func blinkPlayerBoardInColumn(timer: Timer) {
        let info = timer.userInfo as! NSDictionary
        let column = info.value(forKey: "column") as! Int
        playerBoard.blinkColor(inColumn: column, level: currentLevel)
    }

    @objc
    func blinkWholeBoard(timer: Timer) {
        playerBoard.blinkColor(from: currentLevel)

        if currentLevel.hasLevelWon() {
            HapticsController.shared?.hapticVictory()
        } else {
            HapticsController.shared?.hapticBlink()
        }
    }

    func goToResultsScene() {
        if SettingsManager.shared.isSFXEnabled {
			MusicController.sharedInstance.stop()
            MusicController.sharedInstance.play(sound: "Esles_Victory", type: "mp3")
        }
        
        let scene: ResultsScene = ResultsScene(currentLevel: currentLevel)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        super.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
    }
    
    func setQuoteLabel(with txtOne: String) {
        hud.setQuoteLabel(with: txtOne)
    }

    func refreshSceneElements() {
        guard let view else { return }

        removeAllChildren()
        removeAllActions()

        hud = nil
        template = nil
        playerBoard = nil

        self.didMove(to: view)
    }
}
