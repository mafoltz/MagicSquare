//
//  Level.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class Level {
// Level-sensitive info
	var ranking: Int!
	var rounds: Int!
	var maxRounds: Int!
// Game-sensitive info
	var playerBoard: Board!
	var templateBoard: Board!
	
// Board-sensitive info
	var rows: Int!
	var columns: Int!
	
	func loadLevel(_ fileName: String) {
		// adaptar p/ ler do arquivo
		
	}

	func prepareForGame() {
		
		
	}
	
	func hasLevelWon() -> Bool {
		return false
	}
	
}
