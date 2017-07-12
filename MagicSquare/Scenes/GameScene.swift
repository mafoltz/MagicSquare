//
//  GameScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
// MARK: - Properties
	
	private var currentLevel : Level!
	private var playerBoard : [[SKNode]]!
	private var templateBoard : [[SKNode]]!
	private var cellsSize : CGSize!
	private var cellsSpacing : CGFloat!
	private var bottomSpacing : CGFloat!
	private var numPositionMoved : Int!
	
// MARK: - Methods
	
	override func didMove(to view: SKView) {
		
		currentLevel = World.loadLevel(numberOfLevel: 1)
		calculateSizes()
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		
	}
	
	func calculateSizes() {
		self.bottomSpacing = ((self.scene?.size.height)! * 0.045)
		self.cellsSize = CGSize(width: ((self.scene?.size.height)! * CGFloat(0.122)),
		                        height: ((self.scene?.size.height)! * CGFloat(0.122)))
		self.cellsSpacing = ((self.scene?.size.height)! * CGFloat(0.0375))
	}
	
	func setPlayerBoard(board: Board) {
		
	}
	
	func update(row: Int) {
		
	}
	
	func update(column: Int) {
		
	}

}
