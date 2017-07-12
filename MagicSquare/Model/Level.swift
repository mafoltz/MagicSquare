//
//  Level.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class Level: AnyObject {
    
    let number: Int!
    let ranking: Int!
    var playerBoard: Board!
    let templateBoard : Board!
    var playerMoves: Int!
    let maxMoves: Int!
    
    init(levelJson: [String: Any], numberLevel: Int) {
        number = numberLevel
        ranking = 0
        playerBoard = Board(board: levelJson["initialMatrix"] as! [[Int]])
        templateBoard = Board(board: levelJson["templateMatrix"] as! [[Int]])
        playerMoves = 0
        maxMoves = levelJson["moves"] as! Int
    }
	
	func hasLevelWon() -> Bool {
		return false
	}
    
    func hasGameOver() -> Bool {
        return false;
    }
}
