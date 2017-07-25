//
//  Board.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class Board {
    
    // MARK: - Properties
    
    var cellsMatrix: [[BoardCell?]]!
    let numRows: Int!
    let numColumns: Int!
    var isMoving = false
	
    let colors = [UIColor(red: 115/256, green: 134/256, blue: 145/256, alpha: 1.0),
                  UIColor(red: 174/256, green: 210/256, blue: 214/256, alpha: 1.0),
                  UIColor(red: 221/256, green: 144/256, blue: 144/256, alpha: 1.0),
                  UIColor(red: 160/256, green: 072/256, blue: 072/256, alpha: 1.0),
                  UIColor(red: 211/256, green: 114/256, blue: 074/256, alpha: 1.0),
                  UIColor(red: 047/256, green: 066/256, blue: 076/256, alpha: 1.0),
                  UIColor(red: 066/256, green: 074/256, blue: 127/256, alpha: 1.0),
                  UIColor(red: 120/256, green: 172/256, blue: 120/256, alpha: 1.0)]
    
    // MARK: - Methods
    
    init(board: [[Int]]) {
        cellsMatrix = [[BoardCell]]()
        numRows = board.count
        numColumns = board[0].count
        
        for i in 0..<numRows {
            var cellsColumn = [BoardCell]()
            
            for j in 0..<numColumns {
                cellsColumn.append(BoardCell(color: colors[board[i][j]], colorSymbol: board[i][j]))
            }
            
            cellsMatrix.insert(cellsColumn, at: i)
        }
    }
    
    func moveUp(column: Int, positions: Int) {
        isMoving = true
        
        if positions > 0 {
            for _ in 1...positions {
                for i in 0...(numRows - 2) {
                    let newIndex = (i + 1) % numRows
                    (cellsMatrix[i][column], cellsMatrix[newIndex][column]) = (cellsMatrix[newIndex][column], cellsMatrix[i][column])
                }
            }
        }
        
        isMoving = false
    }
    
    func moveDown(column: Int, positions: Int) {
        isMoving = true
        
        if positions > 0 {
            for _ in 1...positions {
                for i in (0...(numRows - 2)).reversed() {
                    let newIndex = (i - 1 + numRows) % numRows
                    (cellsMatrix[i][column], cellsMatrix[newIndex][column]) = (cellsMatrix[newIndex][column], cellsMatrix[i][column])
                }
            }
        }
        
        isMoving = false
    }
    
    func moveLeft(row: Int, positions: Int) {
        isMoving = true
        
        if positions > 0 {
            for _ in 1...positions {
                for i in 0...(numColumns - 2) {
                    let newIndex = (i + 1) % numColumns
                    (cellsMatrix[row][i], cellsMatrix[row][newIndex]) = (cellsMatrix[row][newIndex], cellsMatrix[row][i])
                }
            }
        }
        
        isMoving = false
    }
    
    func moveRight(row: Int, positions: Int) {
        isMoving = true
        
        if positions > 0 {
            for _ in 1...positions {
                for i in (0...(numColumns - 2)).reversed() {
                    let newIndex = (i - 1 + numColumns) % numColumns
                    (cellsMatrix[row][i], cellsMatrix[row][newIndex]) = (cellsMatrix[row][newIndex], cellsMatrix[row][i])
                }
            }
        }
        
        isMoving = false
    }
}
