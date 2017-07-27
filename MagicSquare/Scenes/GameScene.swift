//
//  GameScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

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
        
        if currentLevel.number == 1 {
            setPlayerBoardTutorial(from: view)
        } else {
            setPlayerBoard(from: view)
        }
        
        if !hasGameBegun {
            template.show()
        } else {
            playerBoard.addGestureRecognizer()
        }
        
        MusicController.sharedInstance.play(music: "Esles_Main_Theme", type: "mp3")
        
        let isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        if !isMusicOn{
            MusicController.sharedInstance.music?.pause()
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
        let color = UIColor(red: 174/256, green: 210/256, blue: 214/256, alpha: 1.0)
        hud = Hud(color: color,
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
                playerBoard.blinkColor(from: currentLevel)
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
		let scene: ConfigScene = ConfigScene()
		scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
		scene.size = (super.view?.bounds.size)!
		scene.scaleMode = .aspectFill
		scene.previousScene = self.scene!
		playerBoard.disableGestureRecognizer()
		super.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    func updateMatrixAction(orientation: Orientation, columnOrRow: Int, moves: Int) {
        //        let width = currentLevel.playerBoard.cellsMatrix[1].count
        //        let height = currentLevel.playerBoard.cellsMatrix.count
        if orientation == .vertical && moves > 0 && columnOrRow >= 0 {
            currentLevel.moveUpPlayerBoard(column: columnOrRow, moves: abs(moves))
        } else if orientation == .vertical && moves < 0 && columnOrRow >= 0 {
            currentLevel.moveDownPlayerBoard(column: columnOrRow, moves:abs(moves))
        } else if orientation == .horizontal && moves > 0 && columnOrRow >= 0 {
            currentLevel.moveRightPlayerBoard(row: columnOrRow, moves: abs(moves))
        } else if orientation == .horizontal && moves < 0 && columnOrRow >= 0 {
            currentLevel.moveLeftPlayerBoard(row: columnOrRow, moves: abs(moves))
        }
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.blinkPlayerBoard), userInfo: nil, repeats: false)
    }
    
    func blinkPlayerBoard() {
        playerBoard.blinkColor(from: currentLevel)
    }
    
    func goToResultsScene() {
        MusicController.sharedInstance.stop()
        if UserDefaults.standard.bool(forKey: "isSoundsOn") {
            MusicController.sharedInstance.play(sound: "Esles_Victory", type: "mp3")
        }
        
        let scene: ResultsScene = ResultsScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.currentLevel = currentLevel
        super.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
    }
    
    func setQuoteLabel(with txtOne: String) {
        hud.setQuoteLabel(with: txtOne)
    }
}
