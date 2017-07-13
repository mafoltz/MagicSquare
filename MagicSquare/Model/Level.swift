//
//  Level.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class Level: AnyObject {
    
    let number: Int
    let ranking: Int
    var playerBoard: Board!
    let templateBoard : Board!
    var playerMoves: Int
    let maxMoves: Int
    
    init(levelJson: [String: Any], numberLevel: Int) {
        number = numberLevel
        ranking = 0
        playerBoard = Board(board: levelJson["initialMatrix"] as! [[Int]])
        templateBoard = Board(board: levelJson["templateBoard"] as! [[Int]])
        playerMoves = levelJson["moves"] as! Int
        maxMoves = levelJson["moves"] as! Int
    }
	
    func moveUpPlayerBoard(column: Int, moves: Int) {
        playerBoard.moveUp(column: column, positions: moves)
        playerMoves -= moves
    }
    
    func moveDownPlayerBoard(column: Int, moves: Int) {
        playerBoard.moveDown(column: column, positions: moves)
        playerMoves -= moves
    }
    
    func moveLeftPlayerBoard(row: Int, moves: Int) {
        playerBoard.moveLeft(row: row, positions: moves)
        playerMoves -= moves
    }
    
    func moveRightPlayerBoard(row: Int, moves: Int) {
        playerBoard.moveRight(row: row, positions: moves)
        playerMoves -= moves
    }
    
	func hasLevelWon() -> Bool {
        for i in 0..<playerBoard.numRows {
            for j in 0..<playerBoard.numColumns {
                if !(playerBoard.cellsMatrix[i][j]?.color.isEqual(templateBoard.cellsMatrix[i][j]?.color))! {
                    return false
                }
            }
        }
        
        return true
	}
    
    func hasGameOver() -> Bool {
        if playerMoves == 0 {
            return true
        } else {
            return false;
        }
    }
}
