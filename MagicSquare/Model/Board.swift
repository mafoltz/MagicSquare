//
//  Board.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class Board {
    var cellsMatrix: [[BoardCell?]]!
    
    var colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.black]
    
    init(board: [[Int]]) {
        
        //cellsMatrix = Array(repeating: Array(repeating: nil, count: columns), count: rows)
        cellsMatrix = [[BoardCell]]()
        for i in 0...(board.count) {
            var cellsColumn = [BoardCell]()
            for j in 0...(board[0].count) {
                cellsColumn.append(BoardCell(color: colors[board[i][j]]))
            }
            
            cellsMatrix.insert(cellsColumn, at: i)
        }
    }
}
