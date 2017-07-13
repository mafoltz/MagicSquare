//
//  Board.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit
import SpriteKit

class Board: NSObject {
    
    var cellsMatrix: [[BoardCell?]]!
    let numRows: Int!
    let numColumns: Int!
    var isMoving = false
    
    let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.black]
    
    init(board: [[Int]]) {
        cellsMatrix = [[BoardCell]]()
        numRows = board.count
        numColumns = board[0].count
        
        for i in 0..<numRows {
            var cellsColumn = [BoardCell]()
            
            for j in 0..<numColumns {
                cellsColumn.append(BoardCell(color: colors[board[i][j]]))
            }
            
            cellsMatrix.insert(cellsColumn, at: i)
        }
    }
    
    func moveUp(column: Int, positions: Int) {
        isMoving = true
        
        for i in 0...(numRows - 2) {
            let newIndex = (i - positions + numRows) % numRows
            (cellsMatrix[i][column], cellsMatrix[newIndex][column]) = (cellsMatrix[newIndex][column], cellsMatrix[i][column])
        }
        
        isMoving = false
    }
    
    func moveDown(column: Int, positions: Int) {
        isMoving = true
        
        for i in 0...(numRows - 2) {
            let newIndex = (i + positions) % numRows
            (cellsMatrix[i][column], cellsMatrix[newIndex][column]) = (cellsMatrix[newIndex][column], cellsMatrix[i][column])
        }
        
        isMoving = false
    }
    
    func moveLeft(row: Int, positions: Int) {
        isMoving = true
        
        for _ in 1...positions {
            var cellsRow = cellsMatrix[row]
            let cell = cellsRow.remove(at: 0)!
            cellsRow.insert(cell, at: cellsRow.endIndex)
        }
        
        isMoving = false
    }
    
    func moveRight(row: Int, positions: Int) {
        isMoving = true
        
        for _ in 1...positions {
            var cellsRow = cellsMatrix[row]
            let cell = cellsRow.remove(at: cellsRow.endIndex)!
            cellsRow.insert(cell, at: 0)
        }
        
        isMoving = false
    }
}
