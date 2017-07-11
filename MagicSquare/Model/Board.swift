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
    
    init(rows: Int, columns: Int) {
        cellsMatrix = Array(repeating: Array(repeating: nil, count: columns), count: rows)
    }
}
