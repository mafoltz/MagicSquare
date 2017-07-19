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
    let level: String
    var playerBoard: Board!
    let templateBoard : Board!
    var playerMoves: Int
    let maxMoves: Int
    
    init(from json: [String: Any], numberLevel: Int) {
        number = numberLevel
        ranking = 0
        level = json["level"] as! String
        playerBoard = Board(board: json["initialBoard"] as! [[Int]])
        templateBoard = Board(board: json["templateBoard"] as! [[Int]])
        playerMoves = 0
        maxMoves = json["moves"] as! Int
    }
	
    func moveUpPlayerBoard(column: Int, moves: Int) {
        if !playerBoard.isMoving {
            playerBoard.moveUp(column: column, positions: moves)
            playerMoves += 1
        }
    }
    
    func moveDownPlayerBoard(column: Int, moves: Int) {
        if !playerBoard.isMoving {
            playerBoard.moveDown(column: column, positions: moves)
            playerMoves += 1
        }
    }
    
    func moveLeftPlayerBoard(row: Int, moves: Int) {
        if !playerBoard.isMoving {
            playerBoard.moveLeft(row: row, positions: moves)
            playerMoves += 1
        }
    }
    
    func moveRightPlayerBoard(row: Int, moves: Int) {
        if !playerBoard.isMoving {
            playerBoard.moveRight(row: row, positions: moves)
            playerMoves += 1
        }
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
        if playerMoves <= 0 {
            return true
        } else {
            return false;
        }
    }
}
