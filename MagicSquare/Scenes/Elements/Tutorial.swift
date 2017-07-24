//
//  Tutorial.swift
//  MagicSquare
//
//  Created by Arthur Giachini on 20/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class Tutorial: BoardNode {
    
    func vibrateColumn() {
        let moveUp = SKAction.moveBy(x: 0.0, y: 8, duration: 0.1)
        let moveDown = SKAction.moveBy(x: 0.0, y: -8, duration: 0.1)
        let moves = SKAction.sequence([moveUp, moveDown])
        let wait = SKAction.wait(forDuration: 1.5)
        let bounceUp = SKAction.moveBy(x: 0.0, y: 3.0, duration: 0.1)
        let bounceDown = SKAction.moveBy(x: 0.0, y: -3.0, duration: 0.1)
        let sequence = SKAction.sequence([moves, moves, bounceUp, bounceDown, wait])
        let vibrateColumn = SKAction.repeatForever(sequence)
        for index in 0..<playerBoard.count {
            playerBoard[index][1].run(vibrateColumn)
        }
        
    }
    
    override init(with size: CGSize, board: Board, needsExtraCells: Bool) {
        super.init(with: size, board: board, needsExtraCells: needsExtraCells)
        vibrateColumn()
    }
    
    override func handlePan(recognizer: UIPanGestureRecognizer) {
        super.handlePan(recognizer: recognizer)
        if recognizer.state == .changed {
            for index in 0..<playerBoard.count{
                playerBoard[index][1].removeAllActions()
            }
        }
    }
    
    func async(completion: () -> ()) {
        vibrateColumn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func getRow(with position: CGPoint) -> Int {
        return -1
    }
    
    override func getColumn(with position: CGPoint) -> Int {
        for (index, column) in playerBoard[1].enumerated() {
            
            if index > 0 && index < playerBoard[1].count-1 {
                let newPoint = CGPoint(x: position.x, y: column.position.y)
                if column.contains(newPoint) {
                    if index == 1 {
                        return index
                    }
                }
            }
        }
        return -1
    }
}
