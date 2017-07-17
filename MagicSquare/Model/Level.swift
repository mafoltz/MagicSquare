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
    
    init(from json: [String: Any], numberLevel: Int) {
        number = json["level"] as! Int
        ranking = 0
        playerBoard = Board(board: json["initialBoard"] as! [[Int]])
        templateBoard = Board(board: json["templateBoard"] as! [[Int]])
        playerMoves = json["moves"] as! Int
        maxMoves = json["moves"] as! Int
    }
	
    func moveUpPlayerBoard(column: Int, moves: Int) {
        if !playerBoard.isMoving {
            playerBoard.moveUp(column: column, positions: moves)
            playerMoves -= moves
        }
    }
    
    func moveDownPlayerBoard(column: Int, moves: Int) {
        if !playerBoard.isMoving {
            playerBoard.moveDown(column: column, positions: moves)
            playerMoves -= moves
        }
    }
    
    func moveLeftPlayerBoard(row: Int, moves: Int) {
        if !playerBoard.isMoving {
            playerBoard.moveLeft(row: row, positions: moves)
            playerMoves -= moves
        }
    }
    
    func moveRightPlayerBoard(row: Int, moves: Int) {
        if !playerBoard.isMoving {
            playerBoard.moveRight(row: row, positions: moves)
            playerMoves -= moves
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
