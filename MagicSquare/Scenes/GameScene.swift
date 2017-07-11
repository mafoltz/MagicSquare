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
		let cellHorizontalSpacing = currentLevel.rows
		let cellVerticalSpacing = currentLevel.lines
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		
	}
	
// MARK: - Auxilliary Methods

	func placeBoardCells() {
		
	}

}
