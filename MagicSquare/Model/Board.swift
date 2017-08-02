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
	
	let colors = ["color0" : UIColor(hex: 0x738691),
				  "color1" : UIColor(hex: 0xAED2D6),
                  "color2" : UIColor(hex: 0xDD9090),
                  "color3" : UIColor(hex: 0xA04848),
                  "color4" : UIColor(hex: 0xD3724A),
                  "color5" : UIColor(hex: 0x2F424C),
                  "color6" : UIColor(hex: 0x424A7F),
                  "color7" : UIColor(hex: 0x78AC78)]
    
    // MARK: - Methods
    
    init(board: [[Int]]) {
        cellsMatrix = [[BoardCell]]()
        numRows = board.count
        numColumns = board[0].count
        
        for i in 0..<numRows {
            var cellsColumn = [BoardCell]()
			
            for j in 0..<numColumns {
				cellsColumn.append(BoardCell(color: colors["color" + (board[i][j]).description]! , colorSymbol: board[i][j]))
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

// Para pegar as cores em hexadecimal
extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(hex: Int) {
		self.init(
			red: (hex >> 16) & 0xFF,
			green: (hex >> 8) & 0xFF,
			blue: hex & 0xFF
		)
	}
}
