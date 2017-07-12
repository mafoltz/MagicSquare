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
    var isMoving = false
    
    let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.black]
    
    init(board: [[Int]]) {
        cellsMatrix = [[BoardCell]]()
        
        for i in 0...(board.count) {
            var cellsColumn = [BoardCell]()
            for j in 0...(board[0].count) {
                cellsColumn.append(BoardCell(color: colors[board[i][j]]))
            }
            
            cellsMatrix.insert(cellsColumn, at: i)
        }
    }
    
    func moveUp(column: Int, positions: Int) {
        isMoving = true
        
        for (row, cellsArray) in cellsMatrix.enumerated() {
            for (column, cell) in cellsArray.enumerated() {
                if column == column {

                }
            }
        }
    }
    
    func moveDown(column: Int, positions: Int) {
        isMoving = true
        
        for (row, cellsArray) in cellsMatrix.enumerated() {
            for (column, cell) in cellsArray.enumerated() {
                if column == column {

                }
            }
        }
    }
    
    func moveLeft(row: Int, positions: Int) {
        isMoving = true
        
        var cellsArray = cellsMatrix[row] as! [BoardCell]
        for (row, cell) in cellsArray.enumerated() {
            if row == row {

            }
        }
        
        let cell: BoardCell = cellsArray.remove(at: 0)
        cellsArray.insert(cell, at: cellsArray.count)
    }
    
    func moveRight(row: Int, positions: Int) {
        isMoving = true
        
        let cellsArray = cellsMatrix[row] as! [BoardCell]
        for (row, cell) in cellsArray.enumerated() {
            if row == row {
                
            }
        }
    }
}
