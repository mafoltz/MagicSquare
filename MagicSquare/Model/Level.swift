//
//  Level.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class Level : AnyObject {
    
    var moves : Int!
    var number : Int!
    var templateMatrix : Board!
    var initialMatrix : Board!
    
    init(levelJson: [String: Any], numberLevel: Int) {
        moves = levelJson["moves"] as! Int
        number = numberLevel
        templateMatrix = Board(board: levelJson["templateMatrix"] as! [[Int]])
        initialMatrix = Board(board: levelJson["initialMatrix"] as! [[Int]])
    }
}
