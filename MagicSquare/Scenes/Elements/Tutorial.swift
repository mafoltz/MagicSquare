//
//  Tutorial.swift
//  MagicSquare
//
//  Created by Arthur Giachini on 20/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

enum Move {
    case row
    case column
    case touchInOctopus
    case octopusTouched
}

class Tutorial: BoardNode {
    
    private var initialPoint : CGPoint!
    public var state: Move = .row {
        didSet {
            if state == .octopusTouched {
                updateState()
            }
        }
    }
    
    override init(with size: CGSize, board: Board, needsExtraCells: Bool) {
        super.init(with: size, board: board, needsExtraCells: needsExtraCells)
        vibrateRow()
    }
    
    override var boardDelegate: BoardDelegate? {
        didSet{
            boardDelegate?.setQuoteLabel(with: "Move the indicated row to the right position.")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handlePan(recognizer: UIPanGestureRecognizer) {
        if state == .row || state == .column {
            if recognizer.state == .began {
                removeVibrateRows()
                removeVibrateColumn()
            }
            else if recognizer.state == .ended {
                self.updateState()
            }
        }
        super.handlePan(recognizer: recognizer)
    }
    
    override func getRow(with position: CGPoint) -> Int {
        if state == .row {
            for (index, row) in playerBoard.enumerated() {
                
                if index > 0 && index < playerBoard.count-1{
                    let newPoint = CGPoint(x: row[1].position.x, y: position.y)
                    if row[1].contains(newPoint) {
                        if index == 4 {
                            return index
                        }
                    }
                }
            }
        }
        return -1
    }
    
    override func getColumn(with position: CGPoint) -> Int {
        if state == .column {
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
        }
        return -1
    }
    
    func updateState() {
        print(state)
        if playerBoard[playerBoard.count-2][1].fillColor.description == UIColor(hex: 0x738691).description  && state == .row {
            state = .touchInOctopus
            boardDelegate?.setQuoteLabel(with: "Tap Esle to see the answer again.")
            removeVibrateRows()
        }
        else if state == .octopusTouched {
            boardDelegate?.setQuoteLabel(with: "Move the indicate column down.")
            state = .column
            vibrateColumn()
        }
        else if state == .column {
            vibrateColumn()
        }
        else {
            state = .row
            vibrateRow()
        }
    }
    
    func vibrateColumn() {
        initialPoint = CGPoint(x: playerBoard[playerBoard.count-2][1].position.x, y: playerBoard[playerBoard.count-2][1].position.y)
        for index in 0..<playerBoard.count {
            playerBoard[index][1].initialPosition = playerBoard[index][1].position
            
            var vibrateColumn: SKAction = SKAction()
            
            let moveUp = SKAction.moveBy(x: 0.0, y: -8, duration: 0.1)
            let moveDown = SKAction.moveBy(x: 0.0, y: 8, duration: 0.1)
            let moves = SKAction.sequence([moveUp, moveDown])
            let wait = SKAction.wait(forDuration: 1.5)
            let bounceUp = SKAction.moveBy(x: 0.0, y: -3.0, duration: 0.1)
            let bounceDown = SKAction.moveBy(x: 0.0, y: 3.0, duration: 0.1)
            let sequence = SKAction.sequence([moves, moves, bounceUp, bounceDown, wait])
            vibrateColumn = SKAction.repeatForever(sequence)
            
            playerBoard[index][1].run(vibrateColumn, withKey: "vibrate")
        }
    }
    
    func vibrateRow() {
         initialPoint = CGPoint(x: playerBoard[playerBoard.count-2][1].position.x, y: playerBoard[playerBoard.count-2][1].position.y)
        for index in 0..<playerBoard[0].count {
            playerBoard[playerBoard.count-2][index].initialPosition = playerBoard[playerBoard.count-2][index].position
            
            var vibrateRow: SKAction = SKAction()
            
            let moveLeft = SKAction.moveBy(x: -8, y: 0, duration: 0.1)
            let moveRight = SKAction.moveBy(x: 8, y: 0, duration: 0.1)
            let moves = SKAction.sequence([moveLeft, moveRight])
            let wait = SKAction.wait(forDuration: 1.5)
            let bounceLeft = SKAction.moveBy(x: -3.0, y: 0.0, duration: 0.1)
            let bounceRight = SKAction.moveBy(x: 3.0, y: 0.0, duration: 0.1)
            let sequence = SKAction.sequence([moves, moves, bounceLeft, bounceRight, wait])
            vibrateRow = SKAction.repeatForever(sequence)
            
            playerBoard[playerBoard.count-2][index].run(vibrateRow, withKey: "vibrate")
        }
    }
    
    func removeVibrateColumn() {
        for index in 0..<playerBoard.count {
            if let initialPosition = playerBoard[index][1].initialPosition {
                playerBoard[index][1].run(SKAction.move(to: initialPosition, duration: 0.0))
            }
            playerBoard[index][1].removeAction(forKey: "vibrate")
        }
    }

    func removeVibrateRows() {
        for index in 0..<playerBoard[0].count {
            if let initialPosition = playerBoard[playerBoard.count-2][index].initialPosition {
                playerBoard[playerBoard.count-2][index].run(SKAction.move(to: initialPosition, duration: 0.0))
            }
            playerBoard[playerBoard.count-2][index].removeAction(forKey: "vibrate")
        }
    }
}

//MARK ------------------------------------------ EXTENSION
extension CGFloat {
    static func *(lhs: Int, rhs: CGFloat) -> CGFloat {
        return CGFloat(lhs)*rhs
    }
}
