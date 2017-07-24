//
//  Level.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

enum Coin {
    case golden
    case silver
    case bronze
    case undone
    case locked
}

class Level {
    
    // MARK: - Properties
    
    let number: Int
    let level: String
    var playerBoard: Board!
    let templateBoard : Board!
    var playerMoves: Int
    let movesToGoldenCoin: Int
    let movesToSilverCoin: Int
    var recordMoves: Int
    let locked = false
    
    // MARK: - Methods
    
    init(from json: [String: Any], numberLevel: Int) {
        number = numberLevel
        level = json["level"] as! String
        playerBoard = Board(board: json["initialBoard"] as! [[Int]])
        templateBoard = Board(board: json["templateBoard"] as! [[Int]])
        playerMoves = 0
        movesToGoldenCoin = json["moves"] as! Int
        movesToSilverCoin = 2 * movesToGoldenCoin
        recordMoves = UserDefaults.standard.integer(forKey: level)
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
    
    func getCoinForRecord() -> Coin {
        if locked {
            return .locked
        }
        else if recordMoves <= 0 {
            return .undone
        }
        else if recordMoves <= movesToGoldenCoin {
            return .golden
        }
        else if recordMoves <= movesToSilverCoin {
            return .silver
        }
        else {
            return .bronze
        }
    }
    
    func getCoinForCurrentGame() -> Coin {
        if playerMoves <= movesToGoldenCoin {
            return .golden
        }
        else if playerMoves <= movesToSilverCoin {
            return .silver
        }
        else {
            return .bronze
        }
    }
    
    func getCoinNameForCurrentGame() -> String {
        if playerMoves <= movesToGoldenCoin {
            return "Golden Star"
        }
        else if playerMoves <= movesToSilverCoin {
            return "Silver Star"
        }
        else {
            return "Bronze Star"
        }
    }
    
    func updateRecord() {
        if recordMoves <= 0 || playerMoves < recordMoves {
            recordMoves = playerMoves
            UserDefaults.standard.set(playerMoves, forKey: level)
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
