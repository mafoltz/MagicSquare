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
    
    init(rows: Int, columns: Int) {
        cellsMatrix = Array(repeating: Array(repeating: nil, count: columns), count: rows)
    }
    
    func addPlayerSwipeRecognizer(to view: SKView!) {
        let swipeUp = UISwipeGestureRecognizer()
        swipeUp.direction = .up
        swipeUp.addTarget(self, action: #selector(applySwipeUp))
        view!.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = .down
        swipeDown.addTarget(self, action: #selector(applySwipeDown))
        view!.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.direction = .left
        swipeLeft.addTarget(self, action: #selector(applySwipeLeft))
        view!.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight.addTarget(self, action: #selector(applySwipeRight))
        view!.addGestureRecognizer(swipeRight)
    }
    
    func disablePlayerSwipeRecognizer(to view: SKView!) {
        for gestureRecognizer in view!.gestureRecognizers! {
            if let g: UIGestureRecognizer = gestureRecognizer as UIGestureRecognizer! {
                g.isEnabled = false
            }
        }
    }
    
    func applySwipeUp(sender: UISwipeGestureRecognizer) {
        for row in cellsMatrix {
            for cell in row {
                if (cell?.spriteNode.contains(sender.accessibilityActivationPoint))! {
                    moveUp(column: (cell?.column)!)
                }
            }
        }
    }
    
    func moveUp(column: Int) {
        
    }
    
    func applySwipeDown(column: Int) {
        
    }
    
    func applySwipeLeft(row: Int) {
        
    }
    
    func applySwipeRight(row: Int) {
        
    }
}
