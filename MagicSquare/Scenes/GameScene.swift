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
	
// MARK: - Methods
	
	override func didMove(to view: SKView) {
		
		currentLevel = Level()
		currentLevel.rows = 4
		currentLevel.columns = 4
		
		let cellHorizontalSpacing = ((self.scene?.size.width)! / CGFloat(currentLevel.rows))
		let cellVerticalSpacing = ((self.scene?.size.height)!*0.7 / CGFloat(currentLevel.columns))
		print("cHS: \(cellHorizontalSpacing), cVS: \(cellVerticalSpacing)")
		print("iphone7: \(self.scene?.size.width ?? 0) x \(self.scene?.size.height ?? 0)")
		
		placeBoardCells(cellHorizontalSpacing, cellVerticalSpacing)
	}
	
	override func update(_ currentTime: TimeInterval) {
		
	}
	
// MARK: - Auxilliary Methods

	func placeBoardCells(_ Xspacing: CGFloat,_ Yspacing: CGFloat) {
		var currentX = Xspacing
		var currentY = Yspacing
		
		let cell: BoardCell!
		cell = BoardCell(color: UIColor.gray)
//		for cell in currentLevel.playerBoard.cellsMatrix {
		
		let square = cell.getSpriteNode()
		square.position = CGPoint(x: currentX, y: currentY)
		print("pos: \(square.position)")
		self.addChild(square)
		
		currentY += Yspacing
		currentX += Xspacing
	}

}
