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
    
    let world: String
    let number: Int
    let level: String
    var playerBoard: Board!
    let templateBoard : Board!
    var playerMoves: Int
    let movesToGoldenCoin: Int
    let movesToSilverCoin: Int
    var recordMoves: Int
    var locked = true
    
    // MARK: - Methods
    
    init(from json: [String: Any], worldName: String, numberLevel: Int) {
        world = worldName
        number = numberLevel
        level = json["level"] as! String
        playerBoard = Board(board: json["initialBoard"] as! [[Int]])
        templateBoard = Board(board: json["templateBoard"] as! [[Int]])
        playerMoves = 0
        movesToGoldenCoin = json["moves"] as! Int
        movesToSilverCoin = 2 * movesToGoldenCoin
        
        if number == 1 {
            locked = false
        }
        
        if let recordsDictionary = UserDefaults.standard.dictionary(forKey: world) {
            // Set the record
            if let index = recordsDictionary.index(forKey: "\(number)") {
                recordMoves = recordsDictionary[index].value as! Int
            } else {
                recordMoves = 0
            }
            
            if number > 1, let index = recordsDictionary.index(forKey: "\(number - 1)"), let previousRecord = recordsDictionary[index].value as? Int {
                if previousRecord > 0 {
                    locked = false
                }
            }
        } else {
            recordMoves = 0
        }
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
    
    func getMedalNameForCurrentGame() -> String {
        if playerMoves <= movesToGoldenCoin {
            return "goldMedal"
        }
        else if playerMoves <= movesToSilverCoin {
            return "silverMedal"
        }
        else {
            return "bronzeMedal"
        }
    }
    
    func updateRecord() {
        if recordMoves <= 0 || playerMoves < recordMoves {
            recordMoves = playerMoves
            
            if var recordsDictionary = UserDefaults.standard.dictionary(forKey: world) {
                recordsDictionary.updateValue(playerMoves, forKey: "\(number)")
                UserDefaults.standard.set(recordsDictionary, forKey: world)
            } else {
                var recordsDictionary = Dictionary<String, Any>()
                recordsDictionary.updateValue(playerMoves, forKey: "\(number)")
                UserDefaults.standard.set(recordsDictionary, forKey: world)
            }
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
