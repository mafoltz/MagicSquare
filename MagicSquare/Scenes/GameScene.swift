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
		
		self.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
		currentLevel = World.loadLevel(numberOfLevel: 1)
		calculateSizes()
		setPlayerBoard(board: currentLevel.playerBoard)
		
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
		var xOffset = CGFloat(-cellsSize.width * CGFloat(board.cellsMatrix.count/2))
		var yOffset = CGFloat((self.scene?.size.height)! * CGFloat(0.645) - (cellsSize.height/2))
		
		for row in board.cellsMatrix {
			for cell in row {
				let boardCell = SKShapeNode(rectOf: cellsSize, cornerRadius: 4.0)
				if let color = cell?.color {
					boardCell.fillColor = color
					boardCell.strokeColor = color
				}
				boardCell.position = CGPoint(x: xOffset, y: yOffset)
				self.addChild(boardCell)
				xOffset += cellsSize.width
				yOffset -= cellsSize.height
			}
		}
	}
	
	func update(row: Int) {
		
	}
	
	func update(column: Int) {
		
	}

}
